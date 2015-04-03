class Admin::PrivateLabelsController < Admin::DashboardController

  before_filter :get_private_label, only: [:edit, :update, :destroy]

  def new
    @private_label = PrivateLabel.new
  end

  def create
    @private_label = PrivateLabel.new params[:private_label]
    @private_label.save
    flash[:notice] = "Private Label #{@private_label.name} has been created"
    redirect_to [:admin, :private_labels]
  end

  def edit
  end

  def update
    @private_label.update_attributes params[:private_label]
    flash[:notice] = "Private Label #{@private_label.name} has been updated"
    redirect_to [:admin, :private_labels]
  end

  def index
    @private_labels = PrivateLabel.all
  end

  def destroy
    name = @private_label.name
    @private_label.destroy
    flash[:notice] = "Private Label #{name} has been deleted"
    redirect_to [:admin, :private_labels]
  end

  private
  def get_private_label
    @private_label = PrivateLabel.find params[:id]
  end

end
