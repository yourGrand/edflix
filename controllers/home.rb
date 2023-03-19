require "sinatra"

get "/" do
    erb :home
end

get "/home" do
    erb :home
end
