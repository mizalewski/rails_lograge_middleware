require 'rails/railtie'

module RailsLogrageMiddleware
  Config = Struct.new(:custom_options, :active_job_custom_options)

  class Railtie < Rails::Railtie
    config.rails_lograge_middleware = Config.new

    initializer 'rails_lograge_middleware.configure_middleware' do |app|
      app.middleware.use Middleware
    end

    initializer('rails_lograge_middleware.active_job') do
      ActiveSupport.on_load(:active_job) do
        require 'rails_lograge_middleware/active_job'
        include RailsLogrageMiddleware::ActiveJob
      end
    end
  end
end
