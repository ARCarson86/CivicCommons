class Api::V1::UsersController < Api::V1::BaseController
  def me
    @user = current_person
    empty_user if @user.nil?
  end

  def show
    @user = Person.find params[:id]
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
