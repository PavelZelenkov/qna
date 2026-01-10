class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files, :links, :comments
  has_many :answers
  belongs_to :author

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
  end

  def links
    object.links.map do |link|
      {
        id:   link.id,
        name: link.name,
        url:  link.url
      }
    end
  end

  def comments
    object.comments.map do |comment|
      {
        id:         comment.id,
        body:       comment.body,
        created_at: comment.created_at,
        updated_at: comment.updated_at
      }
    end
  end
end
