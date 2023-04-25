class Article < Sequel::Model
  def title
    article_title.to_s
  end

  def body
    article_body.to_s
  end

  def image
    image_path.to_s
  end
end
