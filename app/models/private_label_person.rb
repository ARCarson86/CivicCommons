class PrivateLabelPerson < ActiveRecord::Base
  include PrivateLabelScopable

  attr_accessible :admin, :person

  belongs_to :person
  belongs_to :private_label
end
