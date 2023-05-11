require "sinatra"

upvote = "upvote"
downvote = "downvote"
no_vote = "no-vote"

get "/courses" do
    @courses = Course.all
    erb :courses
end

# course individual pages
get "/course/:id" do
    id = params[:id]
    @course = Course[course_id: id]
    user_id = User.getUserID(session[:username])
    vote_state = Vote.where(Sequel.ilike(:course, "%#{id}%") & Sequel.ilike(:user, "%#{user_id}%")).first

    # vote check
    if (vote_state.nil?) || (vote_state.downvote_state == 0 && vote_state.upvote_state == 0)
        @upvote = no_vote
        @downvote = no_vote
    elsif vote_state.upvote_state == 1
        @upvote = upvote
        @downvote = no_vote
    elsif vote_state.downvote_state == 1
        @upvote = no_vote
        @downvote = downvote
    end

    erb :course
end

post '/course/:id/button' do
    id = params[:id]
    @course = Course[course_id: id]
    course_rating = @course.rating
    vote = params[:vote]
    user_id = User.getUserID(session[:username])
    
    # update the votes table with the new state of the buttons
    # using the course_id, user_id, upvote_state, and downvote_state values
    # from the form submission

    # find or create a `Vote` record for the given `course_id` and `user_id`
    vote_state = Vote.where(Sequel.ilike(:course, "%#{id}%") & Sequel.ilike(:user, "%#{user_id}%")).first
    if vote_state.nil?
        vote_state = Vote.create(
            user: user_id, 
            course: id, 
            upvote: 0, 
            downvote: 0
        )
    end

    if vote == "upvote"
        if vote_state[:upvote] == 1
            vote_state.update(
                upvote: 0,
                downvote: 0
            )

            @course.update(
                course_rating: course_rating -= 1
            )
        else
            vote_state.update(
                upvote: 1,
                downvote: 0
            )
            @course.update(
                course_rating: course_rating += 1
            )
        end
    else
        if vote_state[:downvote] == 1
            vote_state.update(
                upvote: 0,
                downvote: 0
            )
            @course.update(
                course_rating: course_rating += 1
            )
        else
            vote_state.update(
                upvote: 0,
                downvote: 1
            )
            @course.update(
                course_rating: course_rating -= 1
            )
        end
    end

    if vote_state.upvote_state == 1
        @upvote = upvote
        @downvote = no_vote
    elsif vote_state.downvote_state == 1
        @upvote = no_vote
        @downvote = downvote
    elsif vote_state.downvote_state == 0 && vote_state.upvote_state == 0
        @upvote = no_vote
        @downvote = no_vote
    end
    
    erb :course
end