class Course < Sequel::Model
  def name
    "#{course_title}"
  end

  def about
    "#{course_description}"
  end

  def image
    "#{image_path}"
  end
end