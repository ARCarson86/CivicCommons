class ContentItemDescription < ActiveRecord::Base
  validates :content_type, :presence => true, :uniqueness => true, :inclusion => ['BlogPost']
  validates :description_long, :presence => true
  validates :description_short, :presence => true

  scope :blog_post, lambda {where(:content_type => "BlogPost")}
end
