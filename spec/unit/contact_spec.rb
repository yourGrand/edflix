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
      expect(last_response.body).to include('Contact us')
    end

    # check if failure when firstname not entered
    it 'fails to submit when firstname is not entered' do
      post '/contact', { reason: 'course', firstname: '', lastname: 'Pork', email: 'test@example.com', message: 'Edflix is great!' }
  
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Please fill out all fields')
    end
  
    # check if failure when lastname not entered
    it 'fails to submit when lastname is not entered' do
      post '/contact', { reason: 'course', firstname: 'John', lastname: '', email: 'test@example.com', message: 'Edflix is great!' }
  
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Please fill out all fields')
    end
  
    # check if failure when email not entered
    it 'fails to submit when email is not entered' do
      post '/contact', { reason: 'course', firstname: 'John', lastname: 'Pork', email: '', message: 'Edflix is great!' }
  
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Please fill out all fields')
    end
  
    # check if failure when message not entered
    it 'fails to submit when message is not entered' do
      post '/contact', { reason: 'course', firstname: 'John', lastname: 'Pork', email: 'test@example.com', message: '' }
  
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Please fill out all fields')
    end

  end
end
