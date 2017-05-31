#= RVM ======================================================
require "rvm/capistrano"                 
set :rvm_ruby_string, '2.4.0@mobility_toolbox'

#= Application ==============================================
set :deploy_to, "#{deploysecret(:deploy_to)}#{application}"
set :rails_env, 'production'

#= Git ======================================================
set :branch, "production"

#= Serveur ==================================================
set :user, deploysecret(:user)
set :domain, deploysecret(:domain)
server domain, :app, :web
role :db, domain, :primary => true
set :use_sudo, false


#= Database =================================================
after "bundle:install" do
  run "cp #{release_path}/config/database_production.yml #{release_path}/config/database.yml"
end

#= Delayed Job ==============================================
# require 'delayed/recipes'
# set :delayed_job_command, "bin/delayed_job"
# after "deploy:start", "delayed_job:start"
# after "deploy:stop", "delayed_job:stop"
# after "deploy:restart", "delayed_job:stop"
# after "deploy:restart", "delayed_job:start"

#= Configuration=============================================
default_run_options[:pty] = true