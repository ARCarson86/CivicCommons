class Api::V1::BaseController < ApplicationController

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
