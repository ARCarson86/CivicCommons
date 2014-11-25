class PrivateLabel::Admin::ContributionsController < PrivateLabel::Admin::DashboardController

	def index
		@contributions = @swayze.contributions
	end

	def show
		@contributions = @swayze.contributions.find(params[:id])
	end

	def new
		@contribution = Contribution.new()
	end

	def create
		@contribution = Contribution.new(params[:contribution])
	end
end