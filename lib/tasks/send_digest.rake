namespace :scripts do
  desc 'send out the digest with a time interval'
  task :send_digest, [:interval] => :environment do |t, args|
    DigestService.send_digest(args[:interval])
  end
end