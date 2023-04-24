require "sinatra"

get "/courses" do
    @courses = Course.all
    erb :courses
end

get "/course/:id" do
    id = params[:id]
    @course = Course[course_id: id]
    erb :course
end