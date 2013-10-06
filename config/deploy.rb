# Good Help
# https://help.github.com/articles/deploying-with-capistrano
# https://help.github.com/articles/managing-deploy-keys
# https://help.github.com/articles/using-ssh-agent-forwarding
# https://gist.github.com/jrochkind/2161449

require "bundler/capistrano"
require "rvm/capistrano"


set :deploy_to, "/home/rails/rackspacechess.com"
set :application, "rackspacechess.com"
set :user, "rails"
# ssh_options[:forward_agent] = true
set :ssh_options, { :forward_agent => true }
set :use_sudo, false
set :default_shell, :bash

set :scm, :git
set :repository,  "git@github.com:bwtaylor/pawn-parade.git"
set :branch, 'rax'
set :scm_verbose, true

role :web, "app01.rackspacechess.com", "app02.rackspacechess.com"
role :app, "app01.rackspacechess.com", "app02.rackspacechess.com"
role :db,  "backend01.rackspacechess.com", :primary => true # This is where Rails migrations will run


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

before 'deploy:setup', 'rvm:install_rvm'