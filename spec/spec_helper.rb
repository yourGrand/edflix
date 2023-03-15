# load gems
require "rspec"
require "rack/test"

# load the app
require_relative "../app"

# configure
def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
