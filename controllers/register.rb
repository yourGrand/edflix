require "sinatra"

get '/register' do
  erb :register
end

post "/register" do
  @username = params["username"]
  @email = params["email"]
  @password = params["password"]

  @form_was_submitted = !@username.nil? || !@email.nil? || !@password.nil?

  @submission_error = nil
  @username_error = nil
  @email_error = nil
  @password_error = nil

  if @form_was_submitted
    # sanitise the values by removing whitespace
    @username.strip!
    @email.strip!
    @password.strip!

    # now proceed to validation
    @username_error = "Please enter a value for username" if @username.empty?
    @email_error = "Please enter a value for your E-mail" if @email.empty?
    @password_error = "Please enter a value for your password" if @password.empty?
    if @username_error.nil? && @email_error.nil? && @password_error.nil?
      User.newUser(@username, @password, @email)
      User.login(@username, @password)
      @dashUsername = @username
      @dashEmail = @email
      session[:logged_in] = true
      erb :dashboard
    else
      @submission_error = "Please correct the errors below"
    end
  end
  #erb :register
end
