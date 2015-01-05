class Admin::PrivateLabelsController < Admin::DashboardController

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def index
    @private_labels = PrivateLabel.all
  end

  def show

  end
end