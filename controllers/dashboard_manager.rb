require "sinatra"

get "/dashboard_manager" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        @dashRole = session[:role]
        erb :dashboard_manager
    else
        redirect '/login'
    end
end