module PrivateLabels
  class Page < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :private_label
  end
end
