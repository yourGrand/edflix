# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe "Dashboard page" do
  describe "GET /dashboard" do
    # Check if dashboard loads after logging in
    it "displays user's details on the dashboard" do
      visit "/dashboard"
      add_test_user

      expect(page).to have_content("test123")
      expect(page).to have_content("test123@test.com")

      clear
    end
  end
end
