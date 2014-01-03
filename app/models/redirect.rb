class Redirect < ActiveRecord::Base
  attr_accessible :path, :destination
end
