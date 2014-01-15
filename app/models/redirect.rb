class Redirect < ActiveRecord::Base
  attr_accessible :path, :destination
  validates :path, uniqueness: true, presence: true
  validates :destination, presence: true
end
