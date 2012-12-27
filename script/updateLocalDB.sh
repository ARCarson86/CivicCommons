#!/bin/sh

##
# This script downloads the latest backup from EngineYard and attempts
# load it into a local MySQL database.
#
#  Exit statuses:
#   0 : Success
#   2 : MySQL executable not found or cannot run due to permissions
#   5 : Downloading backup on EngineYard server via eybackup failed
#   6 : Downloading backup to local disk failed
#   7 : Uncompressing the database backup file failed
#   8 : Error uncompressing backup .gz file 
#   9 : MySQL error updating the database

# --------------------------------------------------
#  SETUP
echo " -- Updating local database from latest backup --\n"

# The name of the local database being updated
DB_NAME='TheCivicCommons_dev'

# The name of the user to use to connect to the local MySQL instance
DB_USER='root'

# The remote EngineYard host to get the latest backup from
DB_HOST='ec2-23-22-122-15.compute-1.amazonaws.com'

# The username to connect to the remote EngineYard db host with
USERNAME='deploy'

# The MySQL executable
MYSQL='/usr/local/bin/mysql'
if [ ! -x ${MYSQL} ]
then
  echo "Cannot find MySQL at ${MYSQL}. Aborting . . ."
  exit 2
fi

# Get the name of the latest DB file.  EngineYard is configured 
# to perform a backup nightly and keep 10 of them.  The latest 
# one should be #9.
echo "Getting latest backup file . . . "
BACKUP_FILE=`ssh ${USERNAME}@${DB_HOST} 'sudo -i eybackup -e mysql --l TheCivicCommons' | awk '/9:TheCivicCommons/ { print $2 }'`
if [ -e "${TMPDIR}${BACKUP_FILE}" ]
then
  echo "${BACKUP_FILE} has already been downloaded."
else
  # Now export the file. This command will copy the file to a temporary
  # place on the EngineYard server and then we'll download it.
  ssh ${USERNAME}@${DB_HOST} 'sudo -i eybackup -e mysql --download 9:TheCivicCommons'
  if [ $? -ne 0 ]
  then
    echo "There was an error downloading the MySQL backup file ${BACKUP_FILE} on the EngineYard host. Aborting . . ."
    echo "Please try to download the file manually.  See https://support.cloud.engineyard.com/entries/21009872-view-and-download-database-backups for instructions."
    exit 5
  fi

  # Next step is to download the file from the EngineYard server and
  # stash it in the system temporary directory
  echo ""
  echo "File ${BACKUP_FILE} exported on EngineYard server successfully. Downloading to local disk . . . "
  scp ${USERNAME}@${DB_HOST}:/mnt/tmp/${BACKUP_FILE} $TMPDIR
  if [ $? -eq 0 ]
  then
    echo "Backup file successfully downloaded to ${TMPDIR}${BACKUP_FILE}."
  else
    echo "There was an error downloading ${BACKUP_FILE} from EngineYard. Aborting."
    echo "Please try to download the file manually.  See https://support.cloud.engineyard.com/entries/21009872-view-and-download-database-backups for instructions."
    exit 6
  fi
fi

# Now we'll truncate the local database. Let's make sure the user is
# ready for it.
echo ""
echo "The local database will now be emptied in preparation for loading the new data."
echo "This is a destructive operation and cannot be undone."
while true; do
  read -p "Empty the local database? [y/n] " yn
  case $yn in 
    [Yy]* ) break;;
    [Nn]* ) echo 'Exiting immediately. Your local database has not been changed.'; exit 0;;
    * ) echo "Please answer y (yes) or n (no)";;
  esac
done

echo ""
echo "Unpacking backup file . . . "
SQL_FILENAME=${BACKUP_FILE%.*}
gzcat ${TMPDIR}${BACKUP_FILE} > ${TMPDIR}${SQL_FILENAME}
if [ $? -ne 0 ]
then
  echo "Error unpacking backup file."
  echo "Please try to download the file manually.  See https://support.cloud.engineyard.com/entries/21009872-view-and-download-database-backups for instructions."
  exit 8;
fi

echo ""
echo "Updating ${DB_NAME} database . . . "
${MYSQL} -u ${DB_USER} -D ${DB_NAME} < ${TMPDIR}${SQL_FILENAME}
if [ $? -ne 0 ]
then
  echo "Error while updating database."
  exit 9;
else
  echo "Database updated successfully!"
  exit 0;
fi
