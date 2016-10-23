module RailsLogrageMiddleware
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => ex
        log_exception(ex, env)
        raise
      end

      exception = env['action_dispatch.exception']
      log_exception(exception, env) if exception

      response
    end

    private
    def log_exception(exception, env)
      request = Rack::Request.new(env)

      entry = {
          method: request.request_method,
          path: request.path,
          format: get_format(env),
          controller: env['action_dispatch.request.path_parameters'][:controller],
          action: env['action_dispatch.request.path_parameters'][:action]
      }
      entry[:message] = "Error on #{entry[:path]} (#{entry[:controller]}##{entry[:action]}) #{exception.to_s}"
      entry[:exception] = "#{exception.to_s} at #{exception.backtrace.first.strip}"

      if Rails.configuration.rails_lograge_middleware.custom_options
        custom_options = Rails.configuration.rails_lograge_middleware.custom_options.call(exception, env, request)
        entry.merge! custom_options
      end

      Lograge.logger.presence.error Rails.configuration.lograge.formatter.call(entry)
    end

    def get_format(env)
      formats = env['action_dispatch.request.formats']
      if formats.is_a? Array
        formats[0].try(:symbol)
      end
    end
  end
end