require 'rails_helper'

module PrivateLabels
  module Admin
    RSpec.describe PagesController, :type => :controller do
      it { should be_a PrivateLabels::Admin::BaseController }

      let(:private_label) { create(:private_label) }
      let(:admin) { create :confirmed_person }

    end

  end # Admin module
end # PrivateLabels module
