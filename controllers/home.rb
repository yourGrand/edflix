require "sinatra"

get "/" do
    # sorts array of courses by rating from highest to lowest
    @coursesSortedByRating = Course.all.sort_by(&:rating).reverse
    @articles = Article.all
    erb :home
end
