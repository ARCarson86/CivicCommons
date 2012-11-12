module CivicCommonsDriver
  class OrganizationRegistrationPage
    SHORT_NAME = :organization_registration_page
    LOCATION = '/organizations/register/new'
    include Page
    has_field :bio, "organization_bio"
    has_field :zip_code, "organization_zip_code"
    has_field :name,  'organization_name'
    has_field :email, 'organization_email'
    has_field :password, 'organization_password'
    has_field :password_confirmation, 'organization_password_confirmation'
    has_file_field :avatar, 'organization_avatar'
    has_button :continue, 'Continue', :home
    has_button :continue_with_invalid_information, 'Continue', :organization_registration_page
    
    has_checkbox :i_am_authorized, 'organization_authorized_to_setup_an_account'
    has_checkbox :weekly_newsletter, 'organization_weekly_newsletter'
    has_checkbox :daily_digest, 'organization_daily_digest'
    
    def has_an_error_for? field
      case field
      when :invalid_name
        error_msg = "Name can't be blank"
      when :invalid_email
        error_msg = "Email can't be blank"
      when :invalid_password
        error_msg = "Password can't be blank"
      end
      has_content? error_msg
    end
    
    def fill_in_organization_details_with details
     fill_in_name_with details[:name]
     fill_in_email_with details[:email]
     fill_in_password_with details[:password]
     fill_in_password_confirmation_with details[:password_confirmation]
     attach_avatar_with_file File.join(attachments_path, details[:logo])
     fill_in_bio_with details[:description]
     fill_in_zip_code_with details[:zip_code]
    end
  end
end
