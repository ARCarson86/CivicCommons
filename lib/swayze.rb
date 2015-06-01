class Swayze
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

  ##
  # Convenience method to fetch the people associated with the 
  # current private label. If no private label is set, then the
  # default scope is used to fetch all people.
  def self.people
    if civic_commons?
      Person.scoped
    else
      current_private_label.people
    end
  end

  ##
  # Conv
end
