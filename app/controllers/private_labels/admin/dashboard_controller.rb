module PrivateLabels
  module Admin
    class DashboardController < PlController
      def show
        @admins = @swayze.admins

        @conversations = @swayze.conversations

        @conversations_starting_today = @conversations.where(started_at: (Time.now.beginning_of_day..Time.now.end_of_day))
        @conversations_ending_today = @conversations.where(finished_at: (Time.now.beginning_of_day..Time.now.end_of_day))


        @contributions = @swayze.contributions
        @contributions_today = @contributions.where(created_at: (Time.now.beginning_of_day..Time.now.end_of_day))
      end
    end

  end # Admin module
end # PrivateLabels module
