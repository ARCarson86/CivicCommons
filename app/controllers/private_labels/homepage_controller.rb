module PrivateLabels
  class HomepageController < PlController

    def show
      @people = @swayze.people
      @conversations = @swayze.conversations
    end

  end

end # PrivateLabels module
