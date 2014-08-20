class SubscriptionsController < ApplicationController
  before_filter :require_user

  def subscribe
    Rails.logger.info("We are in the ajax subscribe.")

    subscription = Subscription.subscribe(params[:type], params[:id], current_person)

    if current_person.subscriptions_setting == "realtime"
      subscription.notification_count = 5
    else
      subscription.notification_count = 0
    end

    subscription.save

    respond_to do |format|
      format.html { render :partial => "subscriptions/subscribed", :locals => {:subscribable_type => params[:type], :subscribable_id => params[:id]}, :layout => false}
      format.js
    end
  end

  def unsubscribe
    Rails.logger.info("We are in the ajax unsubscribe.")
    subscription = Subscription.unsubscribe(params[:type], params[:id], current_person)

    respond_to do |format|
      format.html { render :partial => "subscriptions/notsubscribed", :locals => {:subscribable_type => params[:type], :subscribable_id => params[:id]}, :layout => false}
      format.js
    end
  end

end
