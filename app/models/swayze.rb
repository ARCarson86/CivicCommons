class Swayze

	def initialize find_by
    @private_label = get_private_label(find_by)
    @private_label_id = @private_label.id
	end

	def contributions
		Contribution.unscoped.where private_label_id: @private_label_id
	end

	def conversations
		Conversation.unscoped.where private_label_id: @private_label_id
	end

	def people
		@private_label.people
	end

	def admins
		@private_label.admins
	end

	private

	def get_private_label(find_by)
		PrivateLabel.first(conditions: find_by)
	end
end
