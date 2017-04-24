#= RVM ======================================================
require "rvm/capistrano"                 
set :rvm_ruby_string, '2.4.0@mobility_toolbox'

#= Application ==============================================
set :application, "mobility_toolbox" #nom différent en staging pour le mobility_toolboxment
# set :deploy_to, "/home/deploy/www/stagings/#{application}" 
set :deploy_to, "/home/deploy/www/#{application}"  # staging prévu à l'origine pour être al prod
set :rails_env, 'production'

#= Git ======================================================
set :branch, "staging"

#= Serveur ==================================================
set :user, "deploy"
set :domain, "51.254.118.128"
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