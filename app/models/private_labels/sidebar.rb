module PrivateLabels
  class Sidebar < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :private_label

    validates :content, presence: true
  end
end
