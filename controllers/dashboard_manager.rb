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


        where_clauses = []
        where_args = []

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

