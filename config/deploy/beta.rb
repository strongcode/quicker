server 'beta.snapgadget.com', :app, :web, :db, :primary => true

require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.3-p0'
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require 'rvm/capistrano'
set :rvm_path, '$HOME/.rvm'
set :rvm_type, :user # Don't use system-wide RVM

set :app_name, 'snap_gadget_beta'
set :application, 'beta.snapgadget.com'

set :deploy_to, "#{base_path}/#{app_name}"

set :branch, 'beta'

set :rails_env, 'beta'
set :deploy_env, 'beta'
