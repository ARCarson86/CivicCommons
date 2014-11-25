class PrivateLabel::HomepageController < PrivateLabel::ApplicationController

	def show
		@people = @swayze.people
		@conversations = @swayze.conversations
	end
end