class Api::V1::BaseController < ApplicationController

  rescue_from CanCan::AccessDenied do |exception|
    render status: 403, json: {
      error: "Access Denied"
    }
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render status: 404, json: {
      error: "Not Found"
    }
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    Rails.logger.info 'invalid'
    render status: 422, json: {
      error: "Input was invalid"
    }
  end

  protected
  def empty_user
    render status: 401, json: {
      id: nil,
      avatar: Person.new.avatar.url(:medium),
      name: "Civic Commons User",
      location: "#"
    }
  end
end
