class PrivateLabel < ActiveRecord::Base
  ##
  # The only valid values for the color theme
  THEMES = ['green', 'blue', 'orange', 'red', 'gold', 'dark-blue']
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	attr_accessible :name,
                  :namespace,
                  :domain,
                  :logo,
                  :main_image,
                  :favicon,
                  :terms_of_service,
                  :email,
                  :tagline,
                  :title,
                  :phone,
                  :address,
                  :facebook_url,
                  :twitter_url,
                  :linkedin_url,
                  :theme,
                  :fb_api_key,
                  :fb_app_secret,
                  :google_client_id,
                  :google_client_secret,
                  :linkedin_api_key,
                  :linkedin_secret_key,
                  :twitter_api_key,
                  :twitter_api_secret


  has_attached_file :logo,
                    styles: { medium: "300x300>", thumb: "100x100>", header: "x30", footer: "x40" },
                    storage: :s3,
                    s3_credentials: S3Config.credential_file,
                    path: IMAGE_ATTACHMENT_PATH,
                    default_url: '/assets/mark.png'
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  has_attached_file :main_image, 
                    styles: { medium: "300x300>", thumb: "100x100>", main: "1200x300#" },
                    :storage => :s3,
                    :s3_credentials => S3Config.credential_file,
                    :path => IMAGE_ATTACHMENT_PATH
  validates_attachment_content_type :main_image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :favicon,
                    styles: { medium: "16x16" },
                    :storage => :s3,
                    :s3_credentials => S3Config.credential_file,
                    :path => IMAGE_ATTACHMENT_PATH,
                    default_url: '/assets/mark.png'
  validates_attachment_content_type :favicon, content_type: /\Aimage\/.*\Z/

  validate :image_dimensions

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  validates_inclusion_of :theme, in: THEMES, allow_nil: true

  validates :name, presence: true
  validates :email, presence: true
  validates :email, format: EMAIL_FORMAT, allow_blank: true
  validates :namespace, private_label_domain: true

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

  def has_facebook_login?
    self.fb_app_secret.present? && self.fb_api_key.present?
  end

  def has_google_plus_login?
    self.google_client_secret.present? && self.google_client_id.present?
  end

  def has_linkedin_login?
    self.linkedin_secret_key.present? && self.linkedin_api_key.present?
  end

  def has_twitter_login?
    self.twitter_api_secret.present? && self.twitter_api_key.present?
  end

  def has_social_login?
    self.has_facebook_login? || self.has_google_plus_login? || self.has_linkedin_login? || self.has_twitter_login?
  end

  private ##################################################

  ##
  # Make sure that the logo and the main image are big enough
  def image_dimensions
    validate_image_dimensions(:logo, 50, 100)
    validate_image_dimensions(:main_image, 300, 300)
  end

  def validate_image_dimensions(image, height, width)
    obj = self.send(image)
    changed = self.send("#{image}_updated_at_changed?".to_sym)

    return if obj.nil? || !changed
    dimensions = Paperclip::Geometry.from_file(self.send(image).queued_for_write[:original].path)
    errors.add(image, "width must be at least #{width}px") unless dimensions.width >= width
    errors.add(image, "height must be at least #{height}px") unless dimensions.height >= height
  end
end
