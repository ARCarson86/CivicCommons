class PrivateLabel::Admin::UsersController < PrivateLabel::Admin::DashboardController

	def index
		@people = @swayze.people
	end

	def show
		@person = @swayze.people.find(params[:id])
	end

	def new
		@person = Person.new()
	end

	def create
		@person = Person.new(params[:person])
	end
end