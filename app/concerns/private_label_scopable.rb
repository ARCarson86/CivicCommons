module PrivateLabelScopable
  extend ActiveSupport::Concern

  module ClassMethods
    ##
    # Override the default scope for classes to scope to a 
    # particular Private Label if one is set in Swayze.  If
    # there is not one set in Swayze, then scope to only finding
    # records without a private label set.
    def default_scope
      if Swayze.current_private_label.nil?
        where(private_label_id: nil)
      else
        where(private_label_id: Swayze.current_private_label.id)
      end
    end
  end
end
