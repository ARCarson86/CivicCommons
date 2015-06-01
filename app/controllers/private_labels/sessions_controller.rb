module PrivateLabels
  class SessionsController < Devise::SessionsController
    include PrivateLabelControllerConcern

    respond_to :json, only: [:status]

    def status
      @person = current_person
    end
  end
end
