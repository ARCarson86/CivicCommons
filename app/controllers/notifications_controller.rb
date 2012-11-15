class NotificationsController < ApplicationController
  layout :nil

  def show
    @notification = Notification.find(params[:id])
  end

  def index
    @notifications = Notification.all
  end

  def viewed
    if current_person
      Notification.viewed(current_person)

      render :nothing => true
    end
  end
end
