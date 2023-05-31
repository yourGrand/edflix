require "sinatra"

get '/contact' do
    erb :contact
end

post '/contact' do
    # Extract the values from the form data
    @reason = params[:reason]
    @firstname = params[:firstname]
    @lastname = params[:lastname]
    @email = params[:email]
    @message = params[:message]

    if @reason.empty? || @firstname.empty? || @lastname.empty? || @email.empty? || @message.empty?
        @error = "Please fill out all fields"
        erb :contact
    else
        # Save the message in the database
        Contact.send(@firstname, @lastname, @message, @reason, @email)
        erb :contact
    end

end
