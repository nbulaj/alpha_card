$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'alpha_card/version'

Gem::Specification.new do |gem|
  gem.name = 'alpha_card'
  gem.version = AlphaCard::VERSION
  gem.date = '2014-07-24'
  gem.summary = 'Alpha Card Services DirectPost API for Ruby'
  gem.description = 'Gem for creating sales with Alpha Card Services DirectPost API'
  gem.authors = ['Nikita Bulaj']
  gem.email = 'bulajnikita@gmail.com'
  gem.require_paths = ['lib']
  gem.files = `git ls-files`.split($RS)
  gem.homepage = 'http://github.com/budev/alpha_card'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_dependency 'virtus', '~> 1.0'
  gem.add_dependency 'rest_client', '~> 1.7'

  gem.add_development_dependency 'rspec', '~> 3'
end
