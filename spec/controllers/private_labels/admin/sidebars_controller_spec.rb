require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe SidebarsController, type: :controller do
      it { should be_a PrivateLabels::Admin::BaseController }


      describe 'GET #show' do
        let(:private_label)         { create(:private_label) }
        let(:sidebar)         { FactoryGirl.create(:sidebar, private_label: private_label) }

        it 'fetches the current sidebar' do
          get '/'
        end
      end
    end

    

  end # Admin module
end # PrivateLabels module
