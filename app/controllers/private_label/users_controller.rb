class PrivateLabel::UsersController < PrivateLabel::ApplicationController

	def index
		@people = @swayze.people
	end

	def show
		@person = @swayze.people.find(params[:id])
	end

	def new
		@person = Person.new
	end

	def create
		@person = Person.new(params[:person])
	end
end