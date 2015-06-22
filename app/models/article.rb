class Article < ActiveRecord::Base
  include YouTubeable

  def url
    self.video_url
  end

  def url=(value)
    self.video_url = value
  end

  has_attached_file :image,
    :styles => {
       :subfeature => "90x60#",
       :mainfeature => "340x225#" },
    :storage => :s3,
    :s3_credentials => S3Config.credential_file,
    :path => "articles/:attachment/:id/:style/:filename"
  do_not_validate_attachment_file_type :image
  
  ['homepage', 'conversation', 'issue'].each do |type|
    scope :"#{type}_main_article", where(:current => true, :main => true, :"#{type}_article" => true)
    scope :"#{type}_sub_articles", where("main != ? AND current = ? AND #{type}_article = ?", true, true, true)
  end

end
