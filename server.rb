require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'sinatra/namespace'
require 'rollbar/middleware/sinatra'

Rollbar.configure do |config|
  config.enabled = ENV['RACK_ENV'] == 'production'
  config.environment = ENV['RACK_ENV']
  config.access_token = ENV['BACKEND_ROLLBAR_TOKEN']
end

class Backend < Sinatra::Application
  use Rollbar::Middleware::Sinatra
  set :environment, ENV['RACK_ENV']

  config_file 'config/config.yml'

  namespace '/api' do
    get '' do
      json message: 'Main API route'
    end
  end

  not_found do
    status 404
    json error: 'Page not found'
  end
end

