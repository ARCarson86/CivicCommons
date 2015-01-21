module PrivateLabels
  module Admin
    class UsersController < DashboardController

      def index
        @people = @swayze.people
      end

      def show
        @person = @swayze.people.find(params[:id])
      end

      def new
        @person = Person.new()
      end

      def create
        @person = Person.new(params[:person])
      end
    end

  end # Admin module
end # PrivateLabels module
