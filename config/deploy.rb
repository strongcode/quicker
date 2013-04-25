require 'bundler/capistrano'
require 'capistrano_colors'
require 'capistrano-deploytags'
require 'capistrano/ext/multistage'


set :stages, ["testing", "beta","production", "prelive"]
set :default_stage, "testing"

set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 5

set :scm, 'git'
set :user, 'deploy'
set :repository, 'git@qwinixtech.com:snap_gadget.git'
set :base_path, '/var/www/apps'

before 'deploy:assets:precompile', 'deploy:copy_database_yml'
after  'deploy', 'deploy:migrate'
after  'deploy', 'deploy:cleanup'


namespace :deploy do
  desc 'Runs db:migrate on the server.'
  task :migrate, :roles => :db do
    run("cd #{current_path}; bundle exec rake db:migrate RAILS_ENV=#{deploy_env}")
  end

  desc 'Tell Passenger to restart the app.'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Copy to database.yml.example to database.yml"
  task :copy_database_yml do
    run "cp -f #{release_path}/config/database.yml.example #{release_path}/config/database.yml"
  end
end












