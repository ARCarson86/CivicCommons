class PrivateLabelPerson < ActiveRecord::Base
  attr_accessible :admin

  belongs_to :person
  belongs_to :private_label
end
