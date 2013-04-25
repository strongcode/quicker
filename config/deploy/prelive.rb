server '107.20.161.129', :app, :web, :db, :primary => true

require 'rvm/capistrano'

set :rvm_ruby_string, "ruby-1.9.3-p0@rails_3.2.6"
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require 'rvm/capistrano'
set :rvm_path, '/usr/local/rvm'
set :rvm_type, :system # Don't use system-wide RVM

set :app_name, 'snap_gadget_prelive'
set :application, 'prelive.snapgadget.com'

set :deploy_to, "#{base_path}/#{app_name}"

set :branch, 'beta'

set :rails_env, 'prelive'
set :deploy_env, 'prelive'
