require "sinatra"

db = SQLite3::Database.new("./db/test.sqlite3")

get "/dashboard_manager" do
    if session[:logged_in]
        @dashUsername = session[:username]
        @dashEmail = session[:email]
        @dashRole = session[:role]
        @dashNationality = session[:nationality]
        @dashCourses = session[:courses]
        @rows = db.execute("SELECT users.user_id, roles.role, users.first_name, users.surname, genders.gender, users.date_of_birth, countries.country, degrees.degree, courses.course_title, suspensions.suspended, login_details.username
                            FROM users
                            JOIN roles ON users.role = roles.role_id
                            JOIN genders ON users.gender = genders.gender_id
                            JOIN countries ON users.country = countries.country_id
                            JOIN degrees ON users.degree = degrees.degree_id
                            JOIN courses ON users.course = courses.course_id
                            JOIN suspensions ON users.suspended = suspensions.suspension_id
                            JOIN login_details ON users.login = login_details.login_id;")
        @headers = db.execute("PRAGMA table_info(users)").map { |info| info[1] }
        erb :dashboard_manager
    else
        redirect '/login'
    end
end

