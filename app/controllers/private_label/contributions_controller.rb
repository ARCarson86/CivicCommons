class PrivateLabel::ContributionsController < PrivateLabel::ApplicationController

  before_filter :require_user, only: [ :create ]
	def index
		@contributions = @swayze.contributions
	end

	def show
		@contribution = @swayze.contributions.find(params[:id])
	end

	def new
		@contribution = Contribution.new()
	end

	def create
		@contribution = Contribution.new(params[:contribution])
	end
end