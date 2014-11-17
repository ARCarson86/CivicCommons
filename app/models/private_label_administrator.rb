class PrivateLabelAdministrator < ActiveRecord::Base

  belongs_to :person
  belongs_to :private_label
end