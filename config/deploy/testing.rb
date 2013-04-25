server 'qwinixtech.com', :app, :web, :db, :primary => true

set :app_name, 'snap_gadget_dev'
set :application, 'devsg.qwinixtech.com'

set :deploy_to, "#{base_path}/#{app_name}"

set :branch, 'develop'

set :rails_env, 'testing'
set :deploy_env, 'testing'
set :port, 1022
