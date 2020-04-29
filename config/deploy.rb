# config valid for current version and patch releases of Capistrano
lock '~> 3.13.0'

set :chruby_ruby, 'ruby-2.5.5'

set :application, 'modern_ruby_api_wrapper'
set :repo_url, 'git@github.com:NoSoft-SA/modern_ruby_api_wrapper.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml'
append :linked_files, '.env.local', 'mod_ruby_api_wrapper.sh', 'crossbeams-modern_ruby_api_wrapper.service'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: '/opt/ruby/bin:$PATH' }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :chruby_version, -> { fetch(:chruby_ruby) }

namespace :devops do
  desc 'Copy initial files'
  task :copy_initial do
    on roles(:app) do |host|
      upload! 'mod_ruby_api_wrapper.sh.template', "#{shared_path}/mod_ruby_api_wrapper.sh"
      upload! 'crossbeams-modern_ruby_api_wrapper.service.template', "#{shared_path}/crossbeams-modern_ruby_api_wrapper.service"

      execute :sed, "-i 's/$USER/#{host.user}/g' #{shared_path}/crossbeams-modern_ruby_api_wrapper.service"
      execute :sed, "-i 's/$SHARED/#{shared_path.to_s.gsub('/', '\/')}/g' #{shared_path}/crossbeams-modern_ruby_api_wrapper.service"
      execute :sed, "-i 's/$CURRENT/#{current_path.to_s.gsub('/', '\/')}/g' #{shared_path}/crossbeams-modern_ruby_api_wrapper.service"
      execute :sed, "-i 's/$CURRENT/#{current_path.to_s.gsub('/', '\/')}/g' #{shared_path}/mod_ruby_api_wrapper.sh"
      execute :sed, "-i 's/$RUBY/#{fetch(:chruby_version)}/g' #{shared_path}/mod_ruby_api_wrapper.sh"
      # execute :sed, "-i 's/$RUBY/ruby-2.5.0/g' #{shared_path}/mod_ruby_api_wrapper.sh"

      puts('---------------------------------------------------------------------------------------------')
      puts('Now login to the server and copy the service and enable it to start at reboot:')
      puts('sudo cp crossbeams-modern_ruby_api_wrapper.service /etc/systemd/system/crossbeams-modern_ruby_api_wrapper.service')
      puts('sudo systemctl enable crossbeams-modern_ruby_api_wrapper')
      puts('sudo systemctl start crossbeams-modern_ruby_api_wrapper')
      puts('---------------------------------------------------------------------------------------------')

      execute :touch, "#{shared_path}/.env.local"
    end
  end
end

namespace :deploy do
  after :updated, :restart_service do
    on roles(:app) do |_|
      puts('---------------------------------------------------------------------------------------------')
      puts('---')
      puts('--- REMEMBER: Restart the service:: sudo systemctl restart crossbeams-modern_ruby_api_wrapper.service')
      puts('---')
      puts('---------------------------------------------------------------------------------------------')
    end
  end
end
