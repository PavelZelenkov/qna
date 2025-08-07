class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, format: { with: /\A(http|https):\/\/[\w\-]+(\.[\w\-]+)+([\/\w\-.?=&%]*)?\z/i, 
                                            message: "it is not valid URL" }
  
end
