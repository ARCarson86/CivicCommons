class ContentItemLink < ActiveRecord::Base
  belongs_to :content_item

  validates_presence_of :url, :title
  validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :allow_blank => true, :message => 'must look like a url(example http://google.com)'
end
