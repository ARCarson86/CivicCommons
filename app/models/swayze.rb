class Swayze

	def initialize domain
		@domain = domain
	end

	def contributions
		Contribution.unscoped.where private_label_id: get_private_label_id(@domain)
	end

	def conversations
		Conversation.unscoped.where private_label_id: get_private_label_id(@domain)
	end

	private

	def get_private_label_id(domain)
		PrivateLabel.where(namespace: domain).first.id
	end
end