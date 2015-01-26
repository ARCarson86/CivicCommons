module PrivateLabels
  module Admin

    class PeopleController < DashboardController

      before_filter :load_person, only: [:show, :update, :edit]
      before_filter :create_person, only: [:new, :create]

      def index
        @people = @swayze.people
      end

      def show
      end

      def new
      end

      def edit
      end

      def create
      end

      private ##################################################

      ##
      # Fetch the person record to act upon using the id passed
      # in via the params hash and store it in an instance variable.
      def load_person
        @person = @swayze.people.find(params[:id])
      end
    end

  end # Admin module
end # PrivateLabels module
