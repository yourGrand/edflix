require "sinatra"

get "/dashboard" do
    if session[:logged_in]
        # Gather user details from database
        @dashUsername = session[:username]
        @dashEmail = User.getEmail(@dashUsername)
        @dashUserID = User.getUserID(@dashUsername)
        @role = User.getRole(@dashUsername)
        @first_name = User.getFirstName(@dashUserID)
        @surname = User.getSurname(@dashUserID)
        @gender = User.getGender(@dashUserID)
        @date_of_birth = User.getDateOfBirth(@dashUserID)
        @region = User.getRegion(@dashUserID)
        @degree = User.getDegree(@dashUserID)
        @course = User.getCourse(@dashUserID)
        erb :dashboard
    else
        redirect '/login'
    end
end

post "/dashboard" do
  # Gather info from form
  @dashUsername = session[:username]
  @dashEmail = User.getEmail(@dashUsername)
  @dashUserID = User.getUserID(@dashUsername)
  @first_name = params["first_name"]
  @surname = params["surname"]
  @gender = params["gender"]
  @date_of_birth = params["date_of_birth"]
  @region = params["region"]
  @degree = params["degree"]
  @course = User.getCourse(@dashUserID)


  @submission_error = nil
  @first_name_error = nil
  @surname_error = nil
  @gender_error = nil
  @date_of_birth_error = nil
  @region_error = nil
  @degree_error = nil
  @course_error = nil



  # Validation of detail inputs

  @first_name_error = "Please enter a value for first name" if @first_name.empty?

  @surname_error = "Please enter a value for surname" if @surname.empty?
   
  @gender_error = "Please select a gender" if @gender.empty?

  @date_of_birth_error = "Please enter a value for date of birth" if @date_of_birth.empty?

  @region_error = "Please enter a value for region" if @region.empty?

  @degree_error = "Please enter a value for degree" if @degree.empty?
    
  if @first_name_error.nil? && @surname_error.nil? && @gender_error.nil? && @date_of_birth_error.nil? && @region_error.nil? && @degree_error.nil?
    # Sanitise the values by removing whitespace
    @first_name.strip!
    @surname.strip!
    @gender.strip!
    @date_of_birth.strip!
    @region.strip!
    @degree.strip!
    # Add details to database/dashboard display
    User.updateDetails(@dashUserID, @first_name, @surname, @gender, @date_of_birth, @region, @degree)
    redirect '/dashboard'
  else
    @submission_error = "Please correct the errors below"
    redirect '/dashboard'
  end
end
