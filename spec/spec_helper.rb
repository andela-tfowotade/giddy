require "simplecov"
SimpleCov.start
# require 'coveralls'
# Coveralls.wear!
require "factory_girl"

$LOAD_PATH.unshift File.expand_path('../../orm', __FILE__)
require 'base_model'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end
