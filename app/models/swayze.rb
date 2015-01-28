class Swayze

	def initialize(find_by)
    @private_label = get_private_label(find_by)
    @private_label_id = @private_label.id
    Swayze.current_private_label = @private_label
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

  def private_label
    @private_label
  end

  def private_label_id
    @private_label_id
  end

  ##
  # Returns the current PrivateLabel for the thread, if any
  def self.current_private_label
    Thread.current[:current_private_label]
  end

  ##
  # Sets the current PrivateLabel for the thread
  def self.current_private_label=(private_label)
    Thread.current[:current_private_label] = private_label
  end

  ##
  # Checks to see if a private label has been set.  If not, then
  # it should be assumed that the data fetched should be for 
  # Civic Commons.
  def self.civic_commons?
    current_private_label.nil?
  end

  ##
  # Checks to see if a private label has been set.  If there is
  # one, then this returns true.
  def self.private_label?
    !civic_commons?
  end

	private

	def get_private_label(find_by)
		PrivateLabel.first(conditions: find_by) or raise ActiveRecord::RecordNotFound
	end
end
