require 'spec_helper'
require 'sinatra'
require 'sqlite3'

describe 'Learner Dashboard' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:all) do
    @db = SQLite3::Database.new("./db/test_empty.sqlite3")
  end

  after(:all) do
    @db.close
  end

  describe 'GET /dashboard' do
    context 'when user is logged in' do
      before(:each) do
        session = { logged_in: true, username: 'johndoe' }
        allow(User).to receive(:getEmail).with('johndoe').and_return('johndoe@example.com')
        allow(User).to receive(:getUserID).with('johndoe').and_return(1)
        allow(User).to receive(:getRole).with('johndoe').and_return(1)
        allow(User).to receive(:getFirstName).with(1).and_return('John')
        allow(User).to receive(:getSurname).with(1).and_return('Doe')
        allow(User).to receive(:getGender).with(1).and_return(1)
        allow(User).to receive(:getDateOfBirth).with(1).and_return('01/01/2000')
        allow(User).to receive(:getRegion).with(1).and_return(1)
        allow(User).to receive(:getDegree).with(1).and_return(1)
        allow(User).to receive(:getCourse).with(1).and_return(1)
        get '/dashboard', {}, 'rack.session' => session
      end
      it 'responds with status 200' do
        expect(last_response.status).to eq(200)
      end

      it 'renders the dashboard template' do
        expect(last_response.body).to include('Student Edflix Dashboard')
      end

      it 'renders the user details box' do
        expect(last_response.body).to include('First Name:')
        expect(last_response.body).to include('John')
      end
    end
    context 'when user is not logged in' do
      before(:each) do
        session = { logged_in: false }
        get '/dashboard', {}, 'rack.session' => session
      end

      it 'redirects to the login page' do
        expect(last_response.redirect?).to be(true)
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end
end

