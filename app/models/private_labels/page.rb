module PrivateLabels
  class Page < ActiveRecord::Base
    extend FriendlyId
    include ActiveModel::ForbiddenAttributesProtection
    include PrivateLabelScopable

    scope :home_page, -> { where is_home: true }

    belongs_to :private_label
    friendly_id :title, :use => :slugged

    validates :title, presence: true
    validates :content, presence: true
  end
end
