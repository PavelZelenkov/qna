# config valid for current version and patch releases of Capistrano
lock "~> 3.20.0"

set :application, "qna"
set :repo_url, "git@github.com:PavelZelenkov/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key', "config/puma.rb"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

set :rvm_type, :user
set :rvm_ruby_version, "3.1.2"

set :format, :airbrussh
set :log_level, :info

set :puma_threads, [4, 16]
set :puma_workers, 0
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,   "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.access.log"
set :puma_error_log,  "#{shared_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_init_active_record, true
