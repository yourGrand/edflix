# set up database
ENV["APP_ENV"] = "test_empty"

<<<<<<< HEAD
describe 'Login page' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'when the user enters valid credentials' do
    it 'redirects to the dashboard page' do
      post '/login', { username: 'valid_username', password: 'valid_password' }
      expect(last_response.status).to eq(200)
    end
  end
=======
# load helper
require_relative "../spec_helper"
>>>>>>> 0b974ca4382a755f88f3f6f484c54788c2a441c5

describe 'Login page' do
  context 'when the user enters an invalid username' do
    it 'shows an error message' do
      post '/login', { username: 'invalid_username', password: 'valid_password' }
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Incorrect username or password')
    end
  end

  context 'when the user enters an invalid password' do
    it 'shows an error message' do
      post '/login', { username: 'valid_username', password: 'invalid_password' }
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Incorrect username or password')
    end
  end

  context 'when the user leaves both fields blank' do
    it 'shows an error message' do
      post '/login', { username: '', password: '' }
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Please enter both username and password')
    end
  end

  context 'when the user leaves the username field blank' do
    it 'shows an error message' do
      post '/login', { username: '', password: 'valid_password' }
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Please enter your username')
    end
  end

  context 'when the user leaves the password field blank' do
    it 'shows an error message' do
      post '/login', { username: 'valid_username', password: '' }
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Please enter your password')
    end
  end
end
