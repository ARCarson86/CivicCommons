class PrivateLabel::HomepageController < PrivateLabel::PlController

	def show
		@people = @swayze.people
		@conversations = @swayze.conversations
	end

end
