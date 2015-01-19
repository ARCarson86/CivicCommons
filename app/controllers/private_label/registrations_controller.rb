class PrivateLabel::RegistrationsController < Devise::RegistrationsController
  include PrivateLabelControllerConcern

  def new
    resource = build_resource(params["person"])
    resource.authentications.new params["authentication"]
    respond_with_navigational(resource){ render_with_scope :new }
  end

  def create
    if params['person'].has_key?('authentications_attributes')
      params['person']['create_from_auth'] = true
      params['person']['confirmed_at'] = DateTime.now
    end

    if @authentication.present?
      @authentication.save!
    end

    super
  end

end
