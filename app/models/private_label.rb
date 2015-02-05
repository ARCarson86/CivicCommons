class PrivateLabel < ActiveRecord::Base
  ##
  # The only valid values for the color theme
  THEMES = ['green', 'blue', 'orange', 'red', 'gold', 'dark-blue']

	attr_accessible :name,
                  :namespace,
                  :domain,
                  :logo,
                  :main_image,
                  :terms_of_service,
                  :email,
                  :tagline,
                  :title,
                  :phone,
                  :address,
                  :facebook_url,
                  :twitter_url,
                  :linkedin_url,
                  :theme

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>", header: "x30", footer: "x40" }
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  has_attached_file :main_image, styles: { medium: "300x300>", thumb: "100x100>", main: "1200x300#" }
  validates_attachment_content_type :main_image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :favicon, styles: { medium: "16x16" }
  validates_attachment_content_type :favicon, content_type: /\Aimage\/.*\Z/

  validates_inclusion_of :theme, in: THEMES, allow_nil: true

  has_many :private_label_people
  has_many :people, through: :private_label_people
  has_many :admins, through: :private_label_people, source: :person, conditions: ['private_label_people.admin = ?', true]
  has_many :conversations
  has_many :contributions
  has_many :pages, class_name: 'PrivateLabels::Page'
  has_one :sidebar, class_name: 'PrivateLabels::Sidebar'

  # Adds a person to a private label as an administrator
  #
  # @param person the person to add as an administrator
  # @return the PrivateLabel to which the administrator was added
  def add_admin(person)
    private_label_people.create person: person, admin: true
  end

end
