require "sinatra"

db = SQLite3::Database.new("./db/test.sqlite3")

get "/dashboard_manager" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        @dashRole = session[:role]
        @dashNationality = session[:nationality]
        @dashCourses = session[:courses]
        country_filter = params[:country]
        degree_filter = params[:degree]
        id_filter = params[:id]
        role_filter = params[:role]
        fname_filter = params[:forename]
        surname_filter = params[:surname]
        gender_filter = params[:gender]
        course_filter = params[:course]
        suspended_filter = params[:suspended]


        ids = db.execute("SELECT DISTINCT user_id FROM users")
        option_tags = []
        count = 1
        ids.each do |id|
          option_tag = "<option value='#{count},#{id[0]}'>#{id[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_id = option_tags.join("\n")

        roles = db.execute("SELECT DISTINCT role FROM roles")
        option_tags = []
        count = 1
        roles.each do |role|
          option_tag = "<option value='#{count},#{role[0]}'>#{role[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_role = option_tags.join("\n")

        fnames = db.execute("SELECT DISTINCT first_name FROM users")
        option_tags = []
        count = 1
        fnames.each do |fname|
          option_tag = "<option value='#{count},#{fname[0]}'>#{fname[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_fname = option_tags.join("\n")

        surnames = db.execute("SELECT DISTINCT surname FROM users")
        option_tags = []
        count = 1
        surnames.each do |surname|
          option_tag = "<option value='#{count},#{surname[0]}'>#{surname[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_surname = option_tags.join("\n")

        genders = db.execute("SELECT DISTINCT gender FROM genders")
        option_tags = []
        count = 1
        genders.each do |gender|
          option_tag = "<option value='#{count},#{gender[0]}'>#{gender[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_gender = option_tags.join("\n")

        countries = db.execute("SELECT DISTINCT country FROM countries")
        option_tags = []
        count = 1
        countries.each do |country|
          option_tag = "<option value='#{count},#{country[0]}'>#{country[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_country = option_tags.join("\n")

        degrees = db.execute("SELECT DISTINCT degree FROM degrees")
        option_tags = []
        count = 1
        degrees.each do |degree|
          option_tag = "<option value='#{count},#{degree[0]}'>#{degree[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_degree = option_tags.join("\n")

        courses = db.execute("SELECT DISTINCT course_title FROM courses")
        option_tags = []
        count = 1
        courses.each do |course|
          option_tag = "<option value='#{count},#{course[0]}'>#{course[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_course = option_tags.join("\n")

        suspensions = db.execute("SELECT DISTINCT suspended FROM suspensions")
        option_tags = []
        count = 1
        suspensions.each do |suspended|
          option_tag = "<option value='#{count},#{suspended[0]}'>#{suspended[0]}</option>"
          option_tags << option_tag
          count += 1
        end
        @option_tags_suspended = option_tags.join("\n")

        where_clauses = []
        where_args = []

        if id_filter != nil
            id_id, id_name = id_filter.split(",")
            if id_id.to_i > 0
                id_name = db.execute("SELECT users.user_id FROM users WHERE users.user_id = '#{id_name}'")
                where_clauses << "users.user_id = ?"
                where_args << id_name
            end
        end

        if role_filter != nil
            role_id, role_name = role_filter.split(",")
            if role_id.to_i > 0
                role_name = db.execute("SELECT roles.role_id FROM roles WHERE roles.role = '#{role_name}'")
                where_clauses << "users.role = ?"
                where_args << role_name
            end
        end

        if fname_filter != nil
            fname_id, fname_name = fname_filter.split(",")
            if fname_id.to_i > 0
                fname_name = db.execute("SELECT users.first_name FROM users WHERE users.first_name = '#{fname_name}'")
                where_clauses << "users.first_name = ?"
                where_args << fname_name
            end
        end

        if surname_filter != nil
            surname_id, surname_name = surname_filter.split(",")
            if surname_id.to_i > 0
                id_name = db.execute("SELECT users.surname FROM users WHERE users.surname = '#{surname_name}'")
                where_clauses << "users.surname = ?"
                where_args << surname_name
            end
        end

        if gender_filter != nil
            gender_id, gender_name = gender_filter.split(",")
            if gender_id.to_i > 0
                gender_name = db.execute("SELECT genders.gender_id FROM genders WHERE genders.gender = '#{gender_name}'")
                where_clauses << "users.gender = ?"
                where_args << gender_name
            end
        end

        if country_filter != nil
            country_id, country_name = country_filter.split(",")
            if country_id.to_i > 0
                country_name = db.execute("SELECT countries.country_id FROM countries WHERE countries.country = '#{country_name}'")
                where_clauses << "users.country = ?"
                where_args << country_name
            end
        end

        if degree_filter != nil
            degree_id, degree_name = degree_filter.split(",")
            if degree_id.to_i > 0
                degree_name = db.execute("SELECT degrees.degree_id FROM degrees WHERE degrees.degree = '#{degree_name}'")
                where_clauses << "users.degree = ?"
                where_args << degree_name
            end
        end

        if course_filter != nil
            course_id, course_name = course_filter.split(",")
            if course_id.to_i > 0
                course_name = db.execute("SELECT courses.course_id FROM courses WHERE courses.course_title = '#{course_name}'")
                where_clauses << "users.course = ?"
                where_args << course_name
            end
        end

        if suspended_filter != nil
            suspended_id, suspended_name = suspended_filter.split(",")
            if suspended_id.to_i > 0
                suspended_name = db.execute("SELECT suspensions.suspension_id FROM suspensions WHERE suspensions.suspended = '#{suspended_name}'")
                where_clauses << "users.suspended = ?"
                where_args << suspended_name
            end
        end
        
                
        where_sql = where_clauses.empty? ? "" : "WHERE #{where_clauses.join(" AND ")}"
        sql = "SELECT users.user_id, roles.role, users.first_name, users.surname, genders.gender, users.date_of_birth, countries.country, degrees.degree, courses.course_title, suspensions.suspended, login_details.username
            FROM users
            JOIN roles ON users.role = roles.role_id
            JOIN genders ON users.gender = genders.gender_id
            JOIN countries ON users.country = countries.country_id
            JOIN degrees ON users.degree = degrees.degree_id
            JOIN courses ON users.course = courses.course_id
            JOIN suspensions ON users.suspended = suspensions.suspension_id
            JOIN login_details ON users.login = login_details.login_id
            #{where_sql}"
        @rows = db.execute(sql, where_args)
        @headers = db.execute("PRAGMA table_info(users)").map { |info| info[1] }
        erb :dashboard_manager
    else
        redirect '/login'
    end
end

