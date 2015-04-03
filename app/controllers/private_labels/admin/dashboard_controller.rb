module PrivateLabels
  module Admin
    class DashboardController < BaseController

      def show
        @admins = Swayze.current_private_label.admins

        @conversations = Swayze.current_private_label.conversations 

        @conversations_starting_today = @conversations.where(started_at: (Time.now.beginning_of_day..Time.now.end_of_day))
        @conversations_ending_today = @conversations.where(finished_at: (Time.now.beginning_of_day..Time.now.end_of_day))


        @contributions = Swayze.current_private_label.contributions
        @contributions_today = @contributions.where(created_at: (Time.now.beginning_of_day..Time.now.end_of_day))
      end
    end

  end # Admin module
end # PrivateLabels module
