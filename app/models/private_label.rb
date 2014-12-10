class PrivateLabel < ActiveRecord::Base
	attr_accessible :name,
                  :namespace,
                  :domain

  has_many :private_label_administrators
  has_many :private_label_people
  has_many :people, through: :private_label_people
  has_many :admins, through: :private_label_administrators, source: :person
  has_many :conversations
  has_many :contributions

end