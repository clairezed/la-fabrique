#= RVM ======================================================
require "rvm/capistrano"                 
set :rvm_ruby_string, 'RUBY-VERSION@GEMSET'

#= Application ==============================================
set :deploy_to, "/home/deploy/www/stagings/#{application}"
set :rails_env, 'staging'

#= Git ======================================================
set :branch, "master"

#= Serveur ==================================================
set :user, "deploy"
set :domain, "ADDRESSE_IP"
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