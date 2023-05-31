require "sinatra"

get "/" do
    # sorts array of courses by rating from highest to lowest
    @coursesSortedByRating = Course.all.sort_by(&:rating).reverse
    @coursesSortedByRating.delete_if { |course| course.hide_status == 1 }
    erb :home
end
