require "sinatra"

get '/search' do
  @query = params[:search]
  @results = Course.where(Sequel.ilike(:course_title, "%#{@query}%")).all
  erb :search
end