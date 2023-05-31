require 'spec_helper'
require 'sinatra'
require 'sqlite3'

describe 'Dashboard Admin App' do
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

  describe 'GET /dashboard_admin' do
    context 'when user is logged in' do
      before(:each) do
        session = { logged_in: true, username: 'johndoe', email: 'johndoe@example.com',
                    role: 'admin', nationality: 'US', courses: 'math,science' }
        get '/dashboard_admin', {}, 'rack.session' => session
      end

      it 'responds with status 200' do
        expect(last_response.status).to eq(200)
      end

      it 'renders the dashboard_admin template' do
        expect(last_response.body).to include('Admin Dashboard')
      end

    end

    context 'when user is not logged in' do
      before(:each) do
        session = { logged_in: false }
        get '/dashboard_admin', {}, 'rack.session' => session
      end

      it 'redirects to the login page' do
        expect(last_response.redirect?).to be(true)
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end

  end
end



