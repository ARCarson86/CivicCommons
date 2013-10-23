class PromotionFormPresenter < PresenterForm
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :name,
                :email,
                :question,
                :product

  validates_presence_of :email, :name
  validate :email_formatting

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def any_errors?
    errors.any?{|key,val|val.present?}
  end

  def blank_form?
    self.attributes == @object.class.new.attributes
  end

  def persisted?
    false
  end


protected

  def email_formatting
    unless email =~ EmailAddressValidation::PatternExact
      errors.add(:email, " must look like: abc@test.com")
    end
  end


end
