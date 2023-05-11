require 'openssl'
require_relative '../db/db'



class Contact < Sequel::Model(:contact)

    def self.send(firstname, lastname, message, reason, email)
        if Contact.max(:id).nil?
            newID = 0
        else
            newID = User.max(:id) + 1
        end
        
        Contact.insert(id: newID, firstname: firstname, lastname: lastname, message: message, reason: reason, email: email)
    end

end