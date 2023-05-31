# set up database
ENV["APP_ENV"] = "test_empty"

# load helper
require_relative "../spec_helper"

RSpec.describe "Home" do
  describe "Course" do
    course = Course.new(course_title: "Test Course", course_description: "This is a test course.", course_rating: 5,
                        image_path: "images/Test.png")

    it "should return the course name" do
      expect(course.name).to eq("Test Course")
    end

    it "should return the course description" do
      expect(course.about).to eq("This is a test course.")
    end

    it "should return the course rating" do
      expect(course.rating).to eq(5)
    end

    it "should return the course image path" do
      expect(course.image).to eq("images/Test.png")
    end
  end

  describe "Homepage" do
    it "should return a successful response" do
      get "/"
      expect(last_response).to be_ok
    end

    it "should display a list of courses sorted by rating" do
      # create some test courses
      course_a = Course.new(course_title: "Course A", course_description: "Description A", course_rating: 5,
                            image_path: "course_a.jpg")
      course_b = Course.new(course_title: "Course B", course_description: "Description B", course_rating: 3,
                            image_path: "course_b.jpg")
      course_c = Course.new(course_title: "Course C", course_description: "Description C", course_rating: 4,
                            image_path: "course_c.jpg")

      course_a.save_changes
      course_b.save_changes
      course_c.save_changes

      get "/"

      expect(last_response.body).to include("Course A", "Course C", "Course B")

      # clear
      course_a.delete
      course_b.delete
      course_c.delete
    end

    it "should display an empty message when there are no courses or articles" do
      get "/"

      # check that the response body contains the empty message
      expect(last_response.body).to include("The database is empty!")
    end
  end
end
