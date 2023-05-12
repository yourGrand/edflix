require 'spec_helper'
require 'sinatra'
require 'sqlite3'

describe 'Dashboard Manager App' do
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

  describe 'GET /dashboard_manager' do
    context 'when user is logged in' do
      before(:each) do
        session = { logged_in: true, username: 'johndoe', email: 'johndoe@example.com',
                    role: 'manager', nationality: 'US', courses: 'math,science' }
        get '/dashboard_manager', {}, 'rack.session' => session
      end

      it 'responds with status 200' do
        expect(last_response.status).to eq(200)
      end

      it 'renders the dashboard_manager template' do
        expect(last_response.body).to include('Manager Dashboard')
      end

      it 'renders the user ID filter options' do
        expect(last_response.body).to include('<option value=\'1')
      end
    end

    context 'when user is not logged in' do
      before(:each) do
        session = { logged_in: false }
        get '/dashboard_manager', {}, 'rack.session' => session
      end

      it 'redirects to the login page' do
        expect(last_response.redirect?).to be(true)
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end


    context 'when id_filter is present' do
      it 'returns users with the specified user_id' do
        get '/dashboard_manager', { id_filter: '1,5' }, 'rack.session' => { logged_in: true }
        expect(last_response.body).to include('5')
      end
    end

    context 'when role_filter is present' do
      it 'returns users with the specified role' do
        get '/dashboard_manager', { role_filter: '1,Admin' }, 'rack.session' => { logged_in: true }
        expect(last_response.body).to include('Admin')
      end
    end

    context 'when fname_filter is present' do
      it 'returns users with the specified first name' do
        get '/dashboard_manager', { fname_filter: '1,John' }, 'rack.session' => { logged_in: true }
        expect(last_response.body).to include('John')
      end
    end

    context 'when surname_filter is present' do
      it 'returns users with the specified surname' do
        get '/dashboard_manager', { surname_filter: '1,Smith' }, 'rack.session' => { logged_in: true }
        expect(last_response.body).to include('John')
      end
    end
  end
end



