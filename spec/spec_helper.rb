# Uncomment for coverage statistics
# require 'simplecov'
# SimpleCov.start

require 'bundler/setup'
Bundler.setup

require 'alpha_card'

RSpec.configure do |config|
  config.order = 'random'
end