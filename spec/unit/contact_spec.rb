# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe 'contact us page' do
  describe 'GET /contact' do
    #check if the page loads
    it 'loads the contact us page' do
      get '/contact'
      
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Contact Us')
    end


  end
end
