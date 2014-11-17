class PrivateLabel < ActiveRecord::Base
	attr_accessible :name,
                  :namespace,
                  :domain

  has_many :private_label_administrators
  has_many :people, through: :private_label_administrators
  has_many :conversations
  has_many :contributions

  def admins
  	self.private_label_administrators
  end
end