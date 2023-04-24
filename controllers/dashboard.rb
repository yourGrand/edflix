require "sinatra"

get "/dashboard" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        @dashUserID = User.getUserID(@dashUsername)
        @first_name = User.getFirstName(@dashUserID)
        @surname = User.getSurname(@dashUserID)
        @gender = User.getGender(@dashUserID)
        @date_of_birth = User.getDateOfBirth(@dashUserID)
        @country = User.getCountry(@dashUserID)
        @degree = User.getDegree(@dashUserID)
        @course = User.getCourse(@dashUserID)
        erb :dashboard
    else
        redirect '/login'
    end
end

post "/dashboard" do
  @first_name = params["first_name"]
  @surname = params["surname"]
  @gender = params["gender"]
  @date_of_birth = params["date_of_birth"]
  @country = params["country"]
  @degree = params["degree"]
  @course = params["course"]


  @submission_error = nil
  @first_name_error = nil
  @surname_error = nil
  @gender_error = nil
  @date_of_birth_error = nil
  @country_error = nil
  @degree_error = nil
  @course_error = nil



    # now proceed to validation

  @first_name_error = "Please enter a value for first name" if @first_name.empty?

  @surname_error = "Please enter a value for surname" if @surname.empty?
   
  @gender_error = "Please select a gender" if @gender.empty?

  @date_of_birth_error = "Please enter a value for date of birth" if @date_of_birth.empty?

  @country_error = "Please enter a value for country" if @country.empty?

  @degree_error = "Please enter a value for degree" if @degree.empty?

  @course_error = "Please enter a value for course" if @course.empty?
    
  if @first_name_error.nil? && @surname_error.nil? && @gender_error.nil? && @date_of_birth_error.nil? && @country_error.nil? && @degree_error.nil? && @course_error.nil?
    # sanitise the values by removing whitespace
    @first_name.strip!
    @surname.strip!
    @gender.strip!
    @date_of_birth.strip!
    @country.strip!
    @degree.strip!
    @course.strip!
    User.updateDetails(@dashUserID, @first_name, @surname, @gender, @date_of_birth, @country, @degree, @course)
    redirect "/dashboard"
  else
    @submission_error = "Please correct the errors below"
    redirect "/dashboard"
  end
end
