Gem::Specification.new do |s|
  s.name        = 'rails_lograge_middleware'
  s.version     = '1.0.0.1'
  s.summary     = 'Rails middleware for Lograge'
  s.description = 'Rails middleware for Lograge with support to log exceptions from Rails and ActiveJobs'
  s.authors     = ['Michał Zalewski']
  s.email       = 'michal@mzalewski.net'
  s.homepage    = 'https://github.com/mizalewski/rails_lograge_middleware'
  s.license     = 'MIT'

  s.files = `git ls-files lib`.split("\n")

  s.add_development_dependency 'rspec'

  s.add_runtime_dependency 'activesupport', '>= 4', '< 5.1'
  s.add_runtime_dependency 'railties',      '>= 4', '< 5.1'

  s.add_runtime_dependency 'lograge',       '< 1.0'
end
