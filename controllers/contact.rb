get '/contact' do
    erb :contact
end

post '/contact' do
    # Get the parameters from the request body
    name = params[:name]
    email = params[:email]
    message = params[:message]
  
    # Create a new Contact object with the given parameters
    contact = Contact.new(name: name, email: email, message: message)
  
    # Save the contact to the database
    if contact.save
      # Send a success response with the contact's ID
      { id: contact.id }.to_json
    else
      # Send an error response with the validation errors
      { errors: contact.errors.full_messages }.to_json
    end
  end
  