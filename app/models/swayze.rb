class Swayze

	def initialize domain
		@domain = domain
	end

	def contributions
		Contribution.unscoped.where private_label_id: get_private_label(@domain).id
	end

	def conversations
		Conversation.unscoped.where private_label_id: get_private_label(@domain).id
	end

	def people
		get_private_label(@domain).people
	end

	def admins
		get_private_label(@domain).admins
	end

	private

	def get_private_label(domain)
		PrivateLabel.where(namespace: domain).first
	end
end