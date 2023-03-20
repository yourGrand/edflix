# load gems
require "rspec"
require "rack/test"
require "capybara/rspec"

# load the app
require_relative "../app"

# configure
def app
  Sinatra::Application
end

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods
end

# Add a test user
def add_test_user
  visit "/register"
  fill_in "username", with: "learner1"
  fill_in "email", with: "learner1@learner1.com"
  fill_in "password", with: "learner1"
  click_button "Submit"
end

# Log in test user
def login_test_user
  visit "/login"
  fill_in "username", with: "learner1"
  fill_in "password", with: "learner1"
  click_button "Log In"
end

# Log out test user
def logout_test_user
  visit "/logout"
end

# Clear database
def clear
  DB.from("login_details").delete
end