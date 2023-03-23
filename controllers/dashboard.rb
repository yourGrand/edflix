require "sinatra"

get "/dashboard" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        erb :dashboard
    else
        redirect '/login'
    end
end
