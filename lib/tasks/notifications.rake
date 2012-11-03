namespace :notifications do

  desc 'Reduce notifications for users'
  task :limit_user_notifications, [:limit] => :environment do |t, args|
    args.with_defaults(:limit => 50)

    puts "Notifications in the system: #{Notification.count}"
    puts "Notifications limit set to: #{args[:limit]}"
    puts "Processing user notifications..."
    Notification.limit_notifications_per_user(limit: args[:limit].to_i, log:true)

    puts "Notifications in the system: #{Notification.count}"
    puts "Notifications reduction complete."

  end

end
