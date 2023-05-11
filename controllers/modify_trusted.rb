require "sinatra"

# Route for modifying a course
get '/modify_trusted/:id' do |course_id|
  if session[:logged_in] && (User.getRole(session[:username]) == "Trusted")
    @dashUsername = session[:username]
    @dashEmail = session[:email]
    @dashRole = session[:role]
    @dashNationality = session[:nationality]
    @dashCourses = session[:courses]

    # Retrieve the course based on the provided course_id
    @course = Course.where(course_id: course_id).first

    # Check if the course is found
    if @course
      erb :modify_trusted
    else
      # Handle case when the course is not found
      redirect '/trusted_courses'
    end
  else
    redirect '/login'
  end
end

# # Route for handling course modification form submission
# post '/modify_trusted' do
#   if session[:logged_in] && (User.getRole(session[:username]) == "Trusted")
#     course_id = params[:course_id]
#     course_title = params[:coursetitle]
#     course_description = params[:description]
#     course_rating = params[:rating]
#     course_duration = params[:duration]
#     course_pre = params[:prerequisites]

#     # Retrieve the course based on the provided course_id
#     course = Course.where(course_id: course_id).first

#     # Check if the course is found
#     if course
#       # Update the course details
#       course.update(
#         course_title: course_title,
#         course_description: course_description,
#         course_rating: course_rating,
#         course_duration: course_duration,
#         course_pre: course_pre
#       )
#       # Set a session variable to store the confirmation message
#       session[:confirmation_message] = "Course details have been updated successfully."

#       # Redirect back to the trusted courses dashboard or show a success message
#       redirect '/trusted_courses'
#     else
#       # Handle case when the course is not found
#       redirect '/trusted_courses'
#     end
#   else
#     redirect '/login'
#   end
# end
# Route for handling course modification form submission
post '/modify_trusted' do
  if session[:logged_in] && (User.getRole(session[:username]) == "Trusted")
    course_id = params[:course_id]
    course_title = params[:coursetitle]
    course_description = params[:description]
    course_rating = params[:rating]
    course_duration = params[:duration]
    course_pre = params[:prerequisites]

    # Retrieve the course based on the provided course_id
    course = Course.where(course_id: course_id).first

    # Check if the course is found
    if course
      # Update the course details
      course.update(
        course_title: course_title,
        course_description: course_description,
        course_rating: course_rating,
        course_duration: course_duration,
        course_pre: course_pre
      )
      # Set a session variable to store the confirmation message
      session[:confirmation_message] = "Course details have been updated successfully."

      # Render the modify_trusted page with the confirmation message
      @dashUsername = session[:username]
      @dashEmail = session[:email]
      @dashRole = session[:role]
      @dashNationality = session[:nationality]
      @dashCourses = session[:courses]
      @course = course

      erb :modify_trusted
    else
      # Handle case when the course is not found
      redirect '/trusted_courses'
    end
  else
    redirect '/login'
  end
end
