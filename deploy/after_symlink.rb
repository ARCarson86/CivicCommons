rails_env = new_resource.environment["RAILS_ENV"]

execute "rake cache:clear" do
  cwd release_path
  command "bundle exec rake cache:clear"
  environment "RAILS_ENV" => rails_env
  only_if { ::File.exists? "#{release_path}/config/civic_commons.yml" }
end
