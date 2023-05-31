require "sinatra"

get "/edit-course/:id" do
    id = params[:id]
    @course = Course[course_id: id]

    # get image file name instead of the image path
    course_image = @course.image
    @course_img = course_image.gsub(/^images\//, "")

    if !session[:logged_in] || User.getRole(session[:username]) != "Moderator"
        redirect "/login"
    end

    erb :edit_course
end

post "/edit-course/:id" do
    id = params[:id]
    @course = Course[course_id: id]

    # get image file name instead of the image path
    course_image = @course.image
    @course_img = course_image.gsub(/^images\//, "")

    course_title = params["coursetitle"]
    course_about = params["about"]
    course_link = params["courselink"]
    course_img = params["imgname"]
    course_time = params["coursetime"]
    course_pre = params["coursepre"]
  
    # validate user's inputs
    if course_title.empty? && course_about.empty? && 
        course_link.empty? && course_img.empty? && 
        course_time.empty? && course_pre.empty?

        @error = "Please fill in the form"
        erb :add_course
    elsif course_title.empty?
        @error = "Please enter the course title"
        erb :add_course
    elsif course_about.empty?
        @error = "Please enter the course description"
        erb :add_course
    elsif course_link.empty?
        @error = "Please enter the course link"
        erb :add_course
    elsif (course_img.empty?) || ((!course_img.include? ".png") && 
        (!course_img.include? ".jpg") && (!course_img.include? ".jpeg"))

        @error = "Please enter the course image file name with an extension .png, .jpg or .jpeg"
        erb :add_course
    elsif course_time.empty?
        @error = "Please enter the duration of the course"
        erb :add_course
    elsif course_pre.empty?
        @error = "Please enter prerequisites for the course"
        erb :add_course
    else

        # update the record
        @course.update(
            course_title: course_title, 
            course_description: course_about, 
            course_rating: 0, 
            course_link: course_link,
            image_path: "images/" + course_img,
            course_duration: course_time,
            course_pre: course_pre,
            course_trusted: 0
        )
        
        @success = true
        erb :edit_course
    end
end