# test database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe "Courses page" do
  describe "GET /courses" do

    # check if the page loads
    it "has a status code of 200 (OK)" do
      get "/courses"
      expect(last_response.body).to be_ok
    end

    # check if there is a message in case of empty database
    context "with an empty database" do
      it "says the database is empty" do
        get "/courses"
        expect(last_response.body).to include("There are no courses yet")
      end
    end
    
    # check if database works
    context "with one record in the database" do
      it "lists the course" do
        course = Course.new(course_title: "Test", 
          course_description: "You better test your software", 
          image_path: "images/Test.png")
        course.save_changes

        # perform the test by going to the page and examining the content
        get "/list"
        expect(last_response.body).to include("Test")
        expect(last_response.body).to include("You better test your software")

        # reset the state of the database
        DB.from("courses").delete
      end
    end
  end
end