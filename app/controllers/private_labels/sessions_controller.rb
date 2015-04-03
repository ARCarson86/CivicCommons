module PrivateLabels
  class SessionsController < Devise::SessionsController
    include PrivateLabelControllerConcern
  end
end
