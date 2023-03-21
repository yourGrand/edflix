# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe "Register page" do
    describe "GET /register" do
        # check if the page loads
        it "has a status code of 200 (OK)" do
            get "/register"
            expect(last_response).to be_ok
        end

        # check if successful when all fields filled
        it "says Success when the data is ok" do
            get "/register"

            add_test_user
            expect(page).to have_content "Success!"

            # clear database
            clear
        end

        # check if failure when username not entered
        it "rejects the form when username is not filled out" do
            get "/register"

            visit "/register"
            fill_in "email", with: "test@test.com"
            fill_in "password", with: "pass"
            click_button "Submit"

            expect(page).to have_content "Please correct the errors below"
            expect(page).to have_content "Please enter a value for username"
        end

        # check if failure when email not entered
        it "rejects the form when email is not filled out" do
            get "/register"

            visit "/register"
            fill_in "username", with: "test"
            fill_in "password", with: "pass"
            click_button "Submit"

            expect(page).to have_content "Please correct the errors below"
            expect(page).to have_content "Please enter a value for your E-mail"
        end

        # check if failure when password not entered
        it "rejects the form when password is not filled out" do
            get "/register"

            visit "/register"
            fill_in "username", with: "test"
            fill_in "email", with: "test@test.com"
            click_button "Submit"

            expect(page).to have_content "Please correct the errors below"
            expect(page).to have_content "Please enter a value for your password"
        end
    end
end
