# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
#
every :day, :at => '2:00am' do
  runner "DigestService.send_digest", output: { standard: "cron_digest.log", error: "error_digest.log" }
end
every :day, at: "5:00am" do
  rake "notifications:limit_user_notifications", output: { standard: "cron_notification_limit.log", error: "error_notification_limit.log" }
end

# Learn more: http://github.com/javan/whenever
