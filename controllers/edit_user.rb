require "sinatra"

get "/edit-user/*" do
    userID = params[:splat][0]
    @userID = userID
    @username = User.getUsername(@UserID)
    @email = User.getEmail(@username)
    @first_name = User.getFirstName(@UserID)
    @surname = User.getSurname(@UserID)
    @gender = User.getGender(@UserID)
    @date_of_birth = User.getDateOfBirth(@UserID)
    @region = User.getRegion(@UserID)
    @degree = User.getDegree(@UserID)
    @course = User.getCourse(@UserID)
    #@suspension = User.getSuspension(@UserID)

    if !session[:logged_in] || User.getRole(session[:username]) != "Admin"
        redirect "/login"
    end

    erb :edit_user
end

post "/edit-user" do
    

    @username = params["username"] if !params["username"].nil?
    @password = params["password"] if !params["password"].nil?
    @email = params["email"] if !params["email"].nil?
    @first_name = params["first_name"] if !params["first_name"].nil?
    @surname = params["surname"] if !params["surname"].nil?
    @gender = params["gender"] if !params["gender"].nil?
    @date_of_birth = params["date_of_birth"] if !params["date_of_birth"].nil?
    @region = params["region"] if !params["region"].nil?
    @degree = params["degree"] if !params["degree"].nil?
    @course = params["course"] if !params["course"].nil?
    @suspension = params["suspension"] if !params["suspension"].nil?

end




