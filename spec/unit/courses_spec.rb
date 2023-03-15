# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe "Courses page" do
  describe "GET /courses" do
    # check if there is a message in case of empty database
    context "with an empty database" do
      it "says the database is empty" do
        get "/courses"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("The database is empty!")
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
        get "/courses"
        expect(last_response.status).to eq(200)
        expect(course.image_path).to eq("images/Test.png")
        expect(course.name).to eq("Test")
        expect(course.about).to eq("You better test your software")

        # reset the state of the database
        course.delete
      end
    end
  end
end
