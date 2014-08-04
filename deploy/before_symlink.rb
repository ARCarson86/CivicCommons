rails_env = new_resource.environment["RAILS_ENV"]

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

directory "#{deploy[:deploy_to]}/shared/assets" do
  group deploy[:group]
  owner deploy[:user]
  mode 0775
  action :create
  recursive true
end

execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
  only_if { ::File.exists? "#{release_path}/config/civic_commons.yml" }
end
