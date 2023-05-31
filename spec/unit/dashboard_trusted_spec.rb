require_relative "../spec_helper"

describe "the Trusted Dashboard page" do
  before do
    # Mock the session data
    session = {
      logged_in: true,
      username: "testuser",
      email: "testuser@example.com",
      role: "Trusted",
      nationality: "US",
      courses: [
        { course_title: "Course 1", course_rating: 4.5 },
        { course_title: "Course 2", course_rating: 3.8 }
      ]
    }

    allow_any_instance_of(Sinatra::Application).to receive(:session).and_return(session)
  end

  it "displays the list of courses correctly" do
    get '/dashboard_trusted'

    expect(last_response).to be_ok
    expect(last_response.body).to include("Welcome to the Edflix Trusted Course Provider Dashboard")
    expect(last_response.body).to include("Username:")
    expect(last_response.body).to include("testuser")
    expect(last_response.body).to include("Email Address:")
    expect(last_response.body).to include("testuser@example.com")
    expect(last_response.body).to include("Add course")
    expect(last_response.body).to include("Course Details")
    expect(last_response.body).to include("Log Out")
    expect(last_response.body).to include("Reset Password")
    expect(last_response.body).to include("Reset Email")
  end

  it "displays the user information correctly" do
    get '/dashboard_trusted'

    expect(last_response).to be_ok
    expect(last_response.body).to include("testuser")
    expect(last_response.body).to include("testuser@example.com")
  end

  it "renders the add course link" do
    get '/dashboard_trusted'

    expect(last_response).to be_ok
    expect(last_response.body).to include("/add_course")
    expect(last_response.body).to include("Add course")
  end

  it "renders the course details link" do
    get '/dashboard_trusted'

    expect(last_response).to be_ok
    expect(last_response.body).to include("/trusted_courses")
    expect(last_response.body).to include("Course Details")
  end

  it "renders the logout button" do
    get '/dashboard_trusted'

    expect(last_response).to be_ok
    expect(last_response.body).to include("/logout")
    expect(last_response.body).to include("Log Out")
  end

  it "renders the reset password button" do
    get '/dashboard_trusted'

    expect(last_response).to be_ok
    expect(last_response.body).to include("/change_password")
    expect(last_response.body).to include("Reset Password")
  end

  it "renders the reset email button" do
    get '/dashboard_trusted'

    expect(last_response).to be_ok
    expect(last_response.body).to include("/change_email")
    expect(last_response.body).to include("Reset Email")
  end

end
