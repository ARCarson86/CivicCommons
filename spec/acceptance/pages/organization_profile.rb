module CivicCommonsDriver
  class OrganizationProfile
    SHORT_NAME= :organization_profile
    include Page
    
    has_link :join_organization, "I'm a member of this Organization", :organization_profile
    has_link :leave_organization, 'Leave this organization', :organization_profile
    has_link :confirm_joining_organization, "I agree", :organization_profile

    def initialize options
      @slug = options[:for].cached_slug if !options[:for].blank?
    end

    def has_pluralized_itself?
      has_content? "Conversations We Are Following" and
      has_content? "Issues We Are Following" and
      has_content? "Our Recent Activity"
    end

    def has_contact_info_for? organization
      has_content? organization.organization_detail.city and
      has_content? organization.organization_detail.street and
      has_content? organization.organization_detail.postal_code and
      has_content? organization.organization_detail.region and
      has_content? "#{organization.organization_detail.phone}" and
      has_link? "Website", href: organization.website and
      has_link? "Facebook", href: organization.organization_detail.facebook_page and
      has_link? "@#{organization.twitter_username}"
    end

    def has_avatar? person
      has_css? ".img-container[data-member-id='#{person.id}']" and
      has_css? ".img-container[data-member-id='#{person.id}'] img"
    end

    def url
      "/user/#{@slug}"
    end
  end
end

