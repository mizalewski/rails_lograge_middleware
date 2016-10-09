# A [Lograge](https://github.com/roidrage/lograge) extensions for Rails
[![Dependency Status](https://gemnasium.com/mizalewski/rails_lograge_middleware.svg)](https://gemnasium.com/mizalewski/rails_lograge_middleware)

Rails middleware for Lograge with support to log exceptions from Rails and ActiveJobs.

Logs:
* Rails exceptions with more information than pure Lograge. You can add custom fields, which will be logged on exception (user, IP, full exception backtrace etc.).
* Exceptions occurred during running jobs on ActiveJob (Rails 4.2+)

# Installation

Add line to your application's Gemfile:
```ruby
gem 'rails' # minimal version is 4.0
gem 'lograge'
gem 'lograge_rails_middleware'
```

Now, gem should catch all exceptions thrown by Rails and save it to Lograge.

Please remember about [Lograge configuration](https://github.com/roidrage/lograge#installation).

# Custom setup

You can configure additional fields, which will be logged for every exception.

```ruby
# config/initializers/lograge_middleware.rb
Rails.configuration.tap do |config|
  config.rails_lograge_middleware.custom_options = lambda do |exception, env, request|
    # Example of logging remote IP, request ID, params and current logged user
    #
    # == Parameters:
    # exception:
    #   Occurred exception
    # env:
    #   Environment variables hash with request data
    # request:
    #   Request sent to application wrapped in Rack::Request
    #
    # == Returns:
    # Hash with elements to write to log
    #

    controller = env['action_controller.instance'] # current Rails controller
    user = controller.try(:current_user) # we try to get current logged user
    options = {
        remote_ip: request.ip,
        request_id: env['action_dispatch.request_id'],
        # we reject controller and action, because gem log it already
        params: request.params.reject { |key| %w(controller action utf8).include? key }.to_json
    }
    
    if user
      options[:user_id] = user.try(:id)
      options[:user_email] = user.try(:email)
    end
    options
  end
  
  config.rails_lograge_middleware.active_job_custom_options = lambda do |exception, job|
    # Examples of logging ActiveJob arguments
    #
    # == Parameters:
    # exception:
    #   Occurred exception
    # job:
    #   ActiveJob instance, which crashed
    #
    # == Returns:
    # Hash with elements to write to log
    #
    
    options = {
        arguments: job.arguments
    }
    options
  end
end
```
References:

[Rack::Request](http://www.rubydoc.info/gems/rack/Rack/Request)

# Changes

* 1.1.0 - Added ActiveJob exceptions logging
* 1.0.0 - Initial version with requests exception logging
