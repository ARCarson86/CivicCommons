class Api::V1::SessionsController < Api::V1::BaseController
  include Devise::Controllers::InternalHelpers

  def create


    build_resource
    resource = Person.find_for_database_authentication(email: params[:person][:email])
    return invalid_login_attempt unless resource
 
    if resource.valid_password?(params[:person][:password])
      sign_in("person", resource)
      render :json=> {:success=>true, :email=>resource.email}
      return
    end
    render json: {success: false}
    invalid_login_attempt
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out
    render json: {success: true, message: "Logged Out" }
  end

  protected

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end
