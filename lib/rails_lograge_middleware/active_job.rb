module RailsLogrageMiddleware
  module ActiveJob
    extend ActiveSupport::Concern

    included do
      rescue_from(Exception) do |exception|
        log_exception(exception)

        raise exception
      end

      def log_exception(exception)
        entry = {
            job_name: self.class.name,
            job_id: self.job_id,
            queue_name: self.queue_name
        }
        entry[:message] = "Job #{entry[:job_name]} failed #{exception.to_s}"
        entry[:exception] = "#{exception.to_s} at #{exception.backtrace.first.strip}"

        if Rails.configuration.rails_lograge_middleware.active_job_custom_options
          custom_options = Rails.configuration.rails_lograge_middleware.active_job_custom_options.call(exception, self)
          entry.merge! custom_options
        end

        Lograge.logger.presence.error Rails.configuration.lograge.formatter.call(entry)
      end
    end
  end
end
