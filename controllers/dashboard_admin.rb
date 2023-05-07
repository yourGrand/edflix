require "sinatra"

db = SQLite3::Database.new("./db/test.sqlite3")

get "/dashboard_admin" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        @dashRole = session[:role]
        @dashNationality = session[:nationality]
        @dashCourses = session[:courses]
        region_filter = params[:region]
        degree_filter = params[:degree]
        id_filter = params[:id]
        role_filter = params[:role]
        fname_filter = params[:forename]
        surname_filter = params[:surname]
        gender_filter = params[:gender]
        course_filter = params[:course]
        suspended_filter = params[:suspended]

        where_clauses = []
        where_args = []

        where_sql = where_clauses.empty? ? "" : "WHERE #{where_clauses.join(" AND ")}"
        sql = "SELECT users.user_id, roles.role, users.first_name, users.surname, genders.gender, users.date_of_birth, regions.region, degrees.degree, courses.course_title, suspensions.suspended, login_details.username
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