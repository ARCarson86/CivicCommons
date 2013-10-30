run "echo '~~~ Custom After Restart Hooks - Begin...'"
run "echo 'Working on #{config.framework_env} environment.'"

notify_deploy_environments = %w(staging production)
notify_deploy_roles        = %w(solo app_master)

if notify_deploy_environments.include?(config.environment_name) && notify_deploy_roles.include?(config.current_role)
  # Notify Airbrake of deploy
  run "echo 'Setting up AirBrake to send deployment information...'"
  run "echo '  TO: #{config.environment_name.strip}'"
  run "echo '  REVISION: #{config.revision.strip}'"
  run "echo '  REPO: #{config.repo.strip}'"
  run "echo '  USER: `whoami`'"
  run "echo '  cd #{config.release_path} && bundle exec rake airbrake:deploy TO=#{config.environment_name.strip} REVISION=#{config.revision.strip} USER=`whoami` REPO=#{config.repo.strip}'"
  run "cd #{config.release_path} && bundle exec rake airbrake:deploy TO=#{config.environment_name.strip} REVISION=#{config.revision.strip} USER=`whoami` REPO=#{config.repo.strip}"
  run "echo 'Finished setting up AirBrake to send deployment information'"
end

# restart delayed_job process
run "echo 'Restarting delayed_job process...'"
run "echo '  cd #{config.release_path} && bundle exec script/delayed_job restart'"
run "cd #{config.release_path} && bundle exec script/delayed_job restart"
run "echo 'Finished restarting delayed_job process.'"

run "echo '~~~ Custom After Restart Hooks - Complete'"
