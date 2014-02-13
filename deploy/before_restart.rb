rails_env = new_resource.environment["RAILS_ENV"]

if File.exist? "#{release_path}/config/civic_commons.yml"
  Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

  execute "rake assets:precompile" do
    cwd release_path
    command "bundle exec rake assets:precompile"
    environment "RAILS_ENV" => rails_env
  end
else
  Chef::Log.info("No civic_commons.yml - Cannot precompile assets for RAILS_ENV=#{rails_env}...")
end
