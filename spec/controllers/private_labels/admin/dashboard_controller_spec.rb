require 'rails_helper'

module PrivateLabels
  module Admin
    RSpec.describe DashboardController do
      it 'is a PlController subclass' do
        expect(controller).to be_a(PlController)
      end
    end
  end
end
