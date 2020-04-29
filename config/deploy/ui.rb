# VM instance at Unifrutti Somerset West
server '172.16.0.17', user: 'unifrutti', roles: %w[app db web]
set :deploy_to, '/home/unifrutti/modern_ruby_api_wrapper'
set :chruby_ruby, 'ruby-2.5.8'
