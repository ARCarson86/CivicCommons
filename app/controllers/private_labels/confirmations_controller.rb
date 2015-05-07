module PrivateLabels
  class ConfirmationsController < Devise::ConfirmationsController
    include PrivateLabelControllerConcern
  end
end