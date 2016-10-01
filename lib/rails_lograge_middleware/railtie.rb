require 'rails/railtie'

module RailsLogrageMiddleware
  Config = Struct.new(:custom_options)

  class Railtie < Rails::Railtie
    config.rails_lograge_middleware = Config.new

    initializer 'rails_lograge_middleware.configure_middleware' do |app|
      app.middleware.use Middleware
    end
  end
end
