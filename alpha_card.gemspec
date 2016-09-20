$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'alpha_card/version'

Gem::Specification.new do |gem|
  gem.name = 'alpha_card'
  gem.version = AlphaCard::VERSION
  gem.date = '2016-03-24'
  gem.summary = 'Alpha Card Services API for Ruby'
  gem.description = 'Gem for creating sales with Alpha Card Services'
  gem.authors = ['Nikita Bulaj']
  gem.email = 'bulajnikita@gmail.com'
  gem.require_paths = ['lib']
  gem.files = `git ls-files`.split($RS)
  gem.homepage = 'http://github.com/nbulaj/alpha_card'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_runtime_dependency 'virtus', '~> 1.0', '>= 1.0.5'
  gem.add_runtime_dependency 'rack', '~> 2.0', '>= 1.2'

  gem.add_development_dependency 'rspec', '~> 3.5'
end
