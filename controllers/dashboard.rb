require "sinatra"

get "/dashboard" do
    if session[:logged_in]
        erb :dashboard
    else
        redirect '/login'
    end
end
