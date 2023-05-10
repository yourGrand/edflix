require "sinatra"

get '/contact' do
    erb :contact
end

post '/contact' do
    # Extract the values from the form data
    reason = params[:reason]
    firstname = params[:firstname]
    lastname = params[:lastname]
    email = params[:email]
    message = params[:message]

    # Save the message in the database
    User.contact(reason, firstname, lastname, email, message)
end
