class PrivateLabel::Admin::DashboardController < PrivateLabel::PlController
	layout 'private_label/layouts/admin'

  def show
  	@people = @swayze.people
  end
end