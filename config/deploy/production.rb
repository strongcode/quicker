server '50.63.174.108', :app, :web, :db, :primary => true

require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.3-p0'
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require 'rvm/capistrano'
set :rvm_path, '$HOME/.rvm'
set :rvm_type, :user # Don't use system-wide RVM

set :app_name, 'snap_gadget'
set :application, '50.63.174.108'

set :deploy_to, "#{base_path}/#{app_name}"

set :branch, 'master'

set :rails_env, 'production'
set :deploy_env, 'production'
