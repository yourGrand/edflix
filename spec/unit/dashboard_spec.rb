# load helper
require_relative "../spec_helper"

Rspec.describe "Dashboard page" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "GET /dashboard" do

    #Check if page loads
    it "has a status code of 200 (OK)" do
      get "/dashboard"
      expect(last_response.status).to eq(200)
    end