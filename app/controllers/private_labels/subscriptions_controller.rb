module PrivateLabels
  class SubscriptionsController < PrivateLabels::ApplicationController
    before_filter :require_user

    def subscribe

      subscription = Subscription.subscribe(params[:type], params[:id], current_person)

      if current_person.subscriptions_setting == "realtime"
        subscription.notification_count = 5
      else
        subscription.notification_count = 0
      end

      subscription.save

      respond_to do |format|
        format.js {render inline: "location.reload();" }
      end
    end

    def unsubscribe
      subscription = Subscription.unsubscribe(params[:type], params[:id], current_person)

      respond_to do |format|
        format.js {render inline: "location.reload();" }
      end
    end

  end
end
