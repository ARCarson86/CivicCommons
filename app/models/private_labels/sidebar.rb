module PrivateLabels
  class Sidebar < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :private_label
  end
end
