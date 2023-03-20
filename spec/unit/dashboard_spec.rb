# load helper
require_relative "../spec_helper"

RSpec.describe "Dashboard page" do
  describe "GET /dashboard" do
    #Check if page loads
    it "has a status code of 200 (OK)" do
      get "/dashboard"
      expect(last_response.status).to eq(200)
    end

    #Check if page includes body text
    it "says 'Here is where you can access key functions relating to your courses.' " do
      get "/dashboard"
      expect(last_response.body).to include("Here is where you can access key functions relating to your courses.")
    end
  end
end