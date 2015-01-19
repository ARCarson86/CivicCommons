class PrivateLabel::UsersController < PrivateLabel::plController
	before_filter :get_private_user, only: [:show, :edit]

	def show
	end

	def new
		@person = Person.new params[:person]
	end

	def create
		if params[:person_id]
			@person = Person.find(params[:person_id])
		else
			@person = Person.new(params[:person])
			@person.save
		end
		@private_label_person = PrivateLabelPerson.new(private_label_id: @swayze.id, person_id: @person.id)
	end

	def edit
	end

	private

	def get_private_user
		@person = @swayze.people.find(params[:id])
	end
end
