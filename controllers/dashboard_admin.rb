require "sinatra"

db = SQLite3::Database.new("./db/production.sqlite3")

get "/dashboard_admin" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        @dashRole = session[:role]
        @dashNationality = session[:nationality]
        @dashCourses = session[:courses]

        where_clauses = []
        where_args = []

        where_sql = where_clauses.empty? ? "" : "WHERE #{where_clauses.join(" AND ")}"
        sql = "SELECT users.user_id, roles.role, users.first_name, users.surname, genders.gender, users.date_of_birth, regions.region, degrees.degree, courses.course_title, suspensions.suspended, login_details.username, login_details.trusted_provider
            FROM users
            JOIN roles ON users.role = roles.role_id
            JOIN genders ON users.gender = genders.gender_id
            JOIN regions ON users.region = regions.region_id
            JOIN degrees ON users.degree = degrees.degree_id
            JOIN courses ON users.course = courses.course_id
            JOIN suspensions ON users.suspended = suspensions.suspension_id
            JOIN login_details ON users.login = login_details.login_id
            #{where_sql}"
        @rows = db.execute(sql, where_args)
        @headers = db.execute("PRAGMA table_info(users)").map { |info| info[1] }

        erb :dashboard_admin
        
    else
        redirect '/login'
    end
end