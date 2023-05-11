require "sinatra"

get "/edit-user/*" do
    $userID = params[:splat][0]
    @userID = $userID

    if !session[:logged_in] || User.getRole(session[:username]) != "Admin"
        redirect "/login"
    end

    erb :edit_user
end