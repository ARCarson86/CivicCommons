module PrivateLabels
  class PeopleController < PrivateLabels::ApplicationController
    before_filter :get_private_user, only: [:show, :edit]

    def show
    end

    def new
      @person = Person.new
    end

    def create
      if params[:person_id]
        @person = Person.find(params[:person_id])
      else
        @person = Person.new(params[:person])
        @person.save
      end
      @private_label_person = PrivateLabelPerson.new(private_label_id: Swayze.current_private_label.id, person_id: @person.id)
    end

    def edit
    end

    private

    def get_private_user
      @person = Swayze.current_private_label.people.find(params[:id])
    end

  end
end # PrivateLabels module
