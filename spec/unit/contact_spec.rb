# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe 'contact us page' do

  before(:all) do
    # Set up the database connection
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    
    # Create the database schema
    ActiveRecord::Schema.define do
      create_table :contacts do |t|
        t.string :reason
        t.string :firstname
        t.string :lastname
        t.string :email
        t.string :message
        t.timestamps null: false
      end
    end
  end

  before(:each) do
    # Start each test with a clean database
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  after(:each) do
    # Rollback any changes made during the test
    DatabaseCleaner.clean
  end

  it 'submits a valid form' do
    post '/contact', params: {
      reason: 'Course suggestion',
      firstname: 'John',
      lastname: 'Pork',
      email: 'john@example.com',
      message: 'Edflix is great!'
    }

    expect(last_response.status).to eq(302) # redirect status
    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Thank you for your feedback!')

    # Check that the record was created in the database
    expect(Contact.count).to eq(1)
    expect(Contact.first.reason).to eq('Course suggestion')
    expect(Contact.first.firstname).to eq('John')
    expect(Contact.first.lastname).to eq('Pork')
    expect(Contact.first.email).to eq('john@example.com')
    expect(Contact.first.message).to eq('Edflix is great!')
  end
end
