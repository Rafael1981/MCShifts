# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mcshifts'
set :repo_url, 'git@github.com:Rafael1981/MCShifts.git'
set :deploy_to, '/opt/www/mcshifts'
set :user, 'deployer'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}
set :rvm_ruby_version, 'ruby-2.1.5'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call



# set :use_sudo, false
# set :bundle_binstubs, nil
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do

  %w[start stop restart].each do |command|
    desc 'Manage Unicorn'
    task command do
      on roles(:app), in: :sequence, wait: 1 do
        # execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
        execute "/etc/init.d/unicorn #{command}"
      end
    end
  end

  after :publishing, :restart

end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

set :linked_files, %w(config/database.yml)
# set :linked_files, %w(config/database.yml config/secrets.yml)

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# namespace :deploy do
#
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
#
# end
