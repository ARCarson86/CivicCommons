module PrivateLabels
  class HomepageController < ApplicationController

    def show
      @people = @swayze.people
      @conversations = @swayze.conversations
    end

  end

end # PrivateLabels module
