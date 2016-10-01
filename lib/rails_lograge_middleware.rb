require 'rails_lograge_middleware/version'
require 'rails_lograge_middleware/middleware'

module RailsLogrageMiddleware
end

require 'rails_lograge_middleware/railtie' if defined?(Rails)
