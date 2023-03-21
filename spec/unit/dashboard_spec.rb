# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe "Dashboard page" do
  describe "GET /dashboard" do
    # Check if dashboard loads after logging in
    it "says 'Here is where you can access key functions relating to your courses.' " do
      add_test_user
      login_test_user
      expect(page).to have_content "Here is where you can access key functions relating to your courses."
      clear
    end
  end
end
