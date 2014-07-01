Gem::Specification.new do |gem|
  gem.name = 'alpha_card'
  gem.version = '0.1.8'
  gem.date = '2014-07-01'
  gem.summary = 'Alpha Card Services DirectPost API for Ruby'
  gem.description = 'Gem for creating sales with Alpha Card Services DirectPost API'
  gem.authors = ['Nikita Bulaj']
  gem.email = 'bulajnikita@gmail.com'
  gem.require_paths = ["lib"]
  gem.files = `git ls-files`.split($/)
  gem.homepage = 'http://github.com/budev/alpha_card'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_development_dependency "rspec", '~> 3'
end
