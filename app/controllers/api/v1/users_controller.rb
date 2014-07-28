class Api::V1::UsersController < Api::V1::BaseController
  def me
    @user = current_person
    empty_user if @user.nil?
  end

  def show
    @user = Person.find params[:id]
  end
end
