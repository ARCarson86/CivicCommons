run "echo ~~~ Custom Before Restart Hooks - Begin..."
run "echo Working on #{config.framework_env} environment."

current_environment = config.framework_env

# setup the correct timezone: http://docs.engineyard.com/set-time-zone-for-an-appcloud-instance.html
# http://www.timezoneconverter.com/cgi-bin/zoneinfo.tzc?s=default&tz=EST5EDT
# run "sudo ln -sf /usr/share/zoneinfo/EST5EDT /etc/localtime"

# If it's not a production environment, tell robots to not crawl the site
if current_environment != "production"
  run "echo Activate Ignore All robot.txt..."
  run "mv #{config.current_path}/public/robots.txt.ignore.all #{config.current_path}/public/robots.txt"
else
  run "echo Activate Ignore All robot.txt... IGNORE"
end

# Link to Airbrake Config In Staging and Production
if current_environment == "production" || current_environment == "staging"
  run "echo Config Airbrake Connection..."
  run "ln -nfs #{config.shared_path}/config/initializers/airbrake.rb #{config.release_path}/config/initializers/airbrake.rb"
else
  run "echo Config Airbrake Connection....... IGNORE"
end

# Set Server TimeZone to Eastern.
#   Details: https://support.cloud.engineyard.com/entries/21016508-set-the-time-zone-for-an-instance
run "echo Setting Server TimeZone to Eastern \(Detroit\)..."
run "sudo ln -sf /usr/share/zoneinfo/America/Detroit /etc/localtime"
run "ls -alFq /etc/localtime"

# restart delayed_job process
run "echo 'Restarting delayed_job process...'"
run "echo '  cd #{config.release_path} && bundle exec script/delayed_job restart'"
run "cd #{config.release_path} && bundle exec script/delayed_job restart"
run "echo 'Finished restarting delayed_job process.'"

# restart and reindex solr process
if current_environment != "production"
  run "echo 'Starting solr recycling process (stop/start/reindex).'"

  run "echo Listing Current Solr Processes..."
  run "echo '  ps aux | grep solr'"
  run "        ps aux | grep solr"

  run "echo '* Stopping previous solr process...'"
  run "echo '  cd #{config.previous_release} && bundle exec rake sunspot:solr:stop'"
  run "        cd #{config.previous_release} && bundle exec rake sunspot:solr:stop"

  run "echo Listing Current Solr Processes..."
  run "echo '  ps aux | grep solr'"
  run "        ps aux | grep solr"

  run "echo '* Starting solr process...'"
  run "echo '  cd #{config.release_path} && bundle exec rake sunspot:solr:start'"
  run "        cd #{config.release_path} && bundle exec rake sunspot:solr:start"

  run "echo Listing Current Solr Processes..."
  run "echo '  ps aux | grep solr'"
  run "        ps aux | grep solr"

  run "echo '* Reindexing with solr...'"
  run "echo '  cd #{config.release_path} && bundle exec rake sunspot:solr:reindex'"
  run "        cd #{config.release_path} && bundle exec rake sunspot:solr:reindex"

  run "echo 'Finished solr recycling process.'"
end

run "echo ~~~ Custom Before Restart Hooks - Complete..."
