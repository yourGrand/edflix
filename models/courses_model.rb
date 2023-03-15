class Course < Sequel::Model
  def name
    course_title.to_s
  end

  def about
    course_description.to_s
  end

  def image
    image_path.to_s
  end
end
