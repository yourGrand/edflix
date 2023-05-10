require "sinatra"

db = SQLite3::Database.new("./db/test.sqlite3")

get "/dashboard_moderator" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        @dashRole = session[:role]
        @dashNationality = session[:nationality]
        @dashCourses = session[:courses]

        id_filter = params[:id]
        fname_filter = params[:forename]
        surname_filter = params[:surname]



        ids = db.execute("SELECT DISTINCT id FROM contact")
        option_tags = []
        count = 1
        ids.each do |id|
          option_tag = "<option value='#{count},#{id[0]}'>#{id[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_id = option_tags.join("\n")


        fnames = db.execute("SELECT DISTINCT firstname FROM contact")
        option_tags = []
        count = 1
        fnames.each do |fname|
          option_tag = "<option value='#{count},#{fname[0]}'>#{fname[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_fname = option_tags.join("\n")

        surnames = db.execute("SELECT DISTINCT lastname FROM contact")
        option_tags = []
        count = 1
        surnames.each do |surname|
          option_tag = "<option value='#{count},#{surname[0]}'>#{surname[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_surname = option_tags.join("\n")



        where_clauses = []
        where_args = []

        if id_filter != nil
            id_id, id_name = id_filter.split(",")
            if id_id.to_i > 0
                id_name = db.execute("SELECT contact.id FROM contact WHERE contact.id = '#{id_name}'")
                where_clauses << "contact.id = ?"
                where_args << id_name
            end
        end


        if fname_filter != nil
            fname_id, fname_name = fname_filter.split(",")
            if fname_id.to_i > 0
                fname_name = db.execute("SELECT contact.firstname FROM contact WHERE contact.firstname = '#{fname_name}'")
                where_clauses << "contact.firstname = ?"
                where_args << fname_name
            end
        end

        if surname_filter != nil
            surname_id, surname_name = surname_filter.split(",")
            if surname_id.to_i > 0
                id_name = db.execute("SELECT contact.lastname FROM contact WHERE contact.lastname = '#{surname_name}'")
                where_clauses << "contact.lastname = ?"
                where_args << surname_name
            end
        end

               
        where_sql = where_clauses.empty? ? "" : "WHERE #{where_clauses.join(" AND ")}"
        sql = "SELECT contact.id, contact.firstname, contact.lastname, contact.message
            FROM contact
            #{where_sql}"
        @rows = db.execute(sql, where_args)
        @headers = db.execute("PRAGMA table_info(contact)").map { |info| info[1] }
        
        erb :dashboard_moderator
    else
        redirect '/login'
    end
end



