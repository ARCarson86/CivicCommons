rails_env = new_resource.environment["RAILS_ENV"]

execute "npm install" do
  command 'npm install --production'
  user 'deploy'
  cwd release_path
end

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  user 'deploy'
  environment "RAILS_ENV" => rails_env
  only_if { ::File.exists? "#{release_path}/config/civic_commons.yml" }
end
