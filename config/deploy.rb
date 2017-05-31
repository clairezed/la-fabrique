def deploysecret(key)
  @deploy_secrets_yml ||= YAML.load_file('config/deploy_secrets.yml')[fetch(:stage).to_s]
  @deploy_secrets_yml.fetch(key.to_s, 'undefined')
end

#= Multi-stages =============================================
set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

#= Bundler ==================================================
require "bundler/capistrano"

#= Application ==============================================
set :application, "fabrique-mobilite"

#= Git ======================================================
set :scm, "git"
set :repository, "git@github.com:clairezed/mobility-toolbox.git"

#= Liens symboliques vers shared ============================
after "bundle:install" do
  run "rm -rf #{release_path}/public/uploads"
  run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
end

namespace :deploy do

  #= Redémarrage de passenger ===============================
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  #= Seed ===================================================
  task :seed do
    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:seed"
  end

  #= Skip de la précompilation des assets ===================
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end

end

#= Delayed Job ==============================================
# require 'delayed/recipes'
# set :delayed_job_command, "bin/delayed_job"
# after "deploy:start", "delayed_job:start"
# after "deploy:stop", "delayed_job:stop"
# after "deploy:restart", "delayed_job:stop"
# after "deploy:restart", "delayed_job:start"