# load helper
require_relative "../spec_helper"

RSpec.describe "Register page" do
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    describe "GET /register" do
        # check if the page loads
        it "has a status code of 200 (OK)" do
            get "/register"
            expect(last_response.body).to be_ok
        end

        # check if successful when all fields filled
        it "says Success when the data is ok" do
            get "/register", "username" => "Some Text", "email" => "Some Text", "password" => "Some Text"
            expect(last_response.body).to include("Success!")
        end

        # check if failure when username not entered
        it "rejects the form when username is not filled out" do
            get "/register", "email" => "Some Text", "password" => "Some Text"
            expect(last_response.body).to include("Please correct the errors below")
            expect(last_response.body).to include("Please enter a value for username")
        end

        # check if failure when email not entered
        it "rejects the form when email is not filled out" do
            get "/register", "username" => "Some Text", "password" => "Some Text"
            expect(last_response.body).to include("Please correct the errors below")
            expect(last_response.body).to include("Please enter a value for your E-mail")
        end

        # check if failure when password not entered
        it "rejects the form when password is not filled out" do
            get "/register", "username" => "Some Text", "email" => "Some Text"
            expect(last_response.body).to include("Please correct the errors below")
            expect(last_response.body).to include("Please enter a value for your password")
        end
    end
end
