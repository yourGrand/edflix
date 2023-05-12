# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

describe 'Change password page' do
  context 'when the user provides valid input' do
    it 'changes the user password and redirects to the dashboard' do
      # Create a user with a known password
      user = User.create(username: 'test_user', password: 'old_password')

      # Simulate a logged-in session
      post '/login', { username: 'test_user', password: 'old_password' }

      # Change the password
      post '/change_password', { old_password: 'old_password', new_password: 'new_password', confirm_password: 'new_password' }

      # Reload the user from the database
      user.reload

      # Check if the password is changed
      expect(user.password).to eq('new_password')

      # Check if the response is redirected to the dashboard
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/dashboard')
    end
  end

  context 'when the user is not logged in' do
    it 'redirects to the login page' do
      # Attempt to access the change password page without a logged-in session
      get '/change_password'

      # Check if the response is redirected to the login page
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end
  end
end
