class PrivateLabel < ActiveRecord::Base
	attr_accessible :name,
                  :namespace,
                  :domain,
                  :logo,
                  :main_image

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  has_attached_file :main_image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :main_image, :content_type => /\Aimage\/.*\Z/

  has_many :private_label_people
  has_many :people, through: :private_label_people
  has_many :admins, through: :private_label_people, source: :person, conditions: ['private_label_people.admin = ?', true]
  has_many :conversations
  has_many :contributions

end
