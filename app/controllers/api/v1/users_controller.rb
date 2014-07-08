class Api::V1::UsersController < ApplicationController
  def me
    @user = current_person
    render json: { error: "Not signed in" }, status: 401 if @user.nil?
  end

  def show
    @user = Person.find params[:id]
  end
end
