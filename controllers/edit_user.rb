require "sinatra"

get "/edit-user/*" do
    $userID = params[:splat][0]
    @userID = $userID

    if !session[:logged_in] || User.getRole(session[:username]) != "Admin"
        redirect "/login"
    end

    erb :edit_user
end

post "/edit-user" do

    @userID = $userID

    @username = params["username"]
    @email = params["email"]
    @first_name = params["first_name"]
    @surname = params["surname"]

    if params[:gender] == "male"
        @gender = 1
    elsif params[:gender] == "female"
        @gender = 2
    elsif params[:gender] == "other"
        @gender = 3
    else
        @gender = 0
    end

    @date_of_birth = params["date_of_birth"]
    @region = params["region"]
    @degree = params["degree"]

    if params[:suspension] == "TRUE"
        @suspension = "1"
    elsif params[:suspension] == "FALSE"
        @suspension = "2"
    else
        @suspension = "2"
    end

    User.adminUpdate(@userID, @username, @email, @first_name, @surname, @gender, @date_of_birth, @region, @degree, @suspension)

    erb :edit_user
end