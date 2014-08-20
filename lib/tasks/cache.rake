namespace :cache do
  desc "Clear Caches"
  task :clear => :environment do
    if Rails.cache.clear
      puts "Cache Cleared"
    end
  end
end
