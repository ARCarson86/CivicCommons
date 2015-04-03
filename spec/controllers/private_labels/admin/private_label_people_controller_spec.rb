require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe PrivateLabelPeopleController do
      let(:private_label)         { create(:private_label) }
      let(:admin)                 { create(:confirmed_person) }
      let(:other_private_label)   { create(:private_label) }

      before(:each) do
        Swayze.current_private_label = private_label
        @admin_plp = create(:private_label_person, person: admin, private_label: private_label, admin: true)
        sign_in admin
      end

      it { should be_a PrivateLabels::Admin::BaseController }

      describe 'GET #index' do
        let!(:current_plps)         { create_list(:private_label_person, 3, private_label: private_label) }
        let!(:other_plps)           { create_list(:private_label_person, 3, private_label: other_private_label) }
        before(:each)               { current_plps << @admin_plp }

        it 'fetches only the records for the private label' do
          get :index
          expect(assigns[:private_label_people]).to match_array(current_plps)
        end

        it 'does not fetch records for another private label' do
          get :index
          fetched = assigns[:private_label_people]
          other_plps.each { |p| expect(fetched).not_to include(p) }
        end
      end

      describe 'PUT #toggle_admin' do
        let!(:current_plp)        { create(:private_label_person, private_label: private_label, admin: admin_value) }
        let!(:other_plp)          { create(:private_label_person, private_label: other_private_label) }
        let(:admin_value)         { false }
        let(:new_value)           { 1 }
        let(:params)              { { id: current_plp.id } }

        it 'fetches the record if it is in the current private label' do
          put :toggle_admin, params
          expect(assigns[:private_label_person]).to eq(current_plp)
        end

        it 'does cannot find a record from another private label' do
          expect { put :toggle_admin, id: other_plp.id }.to raise_error(ActiveRecord::RecordNotFound)
        end

        context 'when the record is updated successfully' do
          before(:each) do
            allow(PrivateLabelPerson).to receive(:find).with(current_plp.id.to_s).and_return(current_plp)
            expect(current_plp).to receive(:save).and_return(true)
          end

          context 'and admin is true' do
            let(:admin_value)         { true }

            it 'sets admin to false' do
              put :toggle_admin, params
              expect(current_plp.admin).to be_falsey
            end
          end

          context 'and admin is false' do
            let(:admin_value)         { false }

            it 'sets admin to true' do
              put :toggle_admin, params
              expect(current_plp.admin).to be_truthy
            end
          end

          it 'redirects to the index path' do
            put :toggle_admin, params
            expect(response).to redirect_to(private_labels_admin_private_label_people_path)
          end

          it 'sets a success message in the flash notice' do
            put :toggle_admin, params
            expect(flash.notice).to match(/.+success.+/)
          end
        end

        context 'when the record is updated successfully' do
          before(:each) do
            allow(PrivateLabelPerson).to receive(:find).with(current_plp.id.to_s).and_return(current_plp)
            expect(current_plp).to receive(:save).and_return(true)
          end

          it 'redirects to the index path' do
            put :toggle_admin, params
            expect(response).to redirect_to(private_labels_admin_private_label_people_path)
          end

          it 'sets a success message in the flash notice' do
            put :toggle_admin, params
            expect(flash.notice).to match(/.+success.+/)
          end
        end

        context 'when the record is not updated successfully' do
          before(:each) do
            allow(PrivateLabelPerson).to receive(:find).with(current_plp.id.to_s).and_return(current_plp)
            expect(current_plp).to receive(:save).and_return(false)
          end

          it 'redirects to the index path' do
            put :toggle_admin, params
            expect(response).to redirect_to(private_labels_admin_private_label_people_path)
          end

          it 'sets an error message in the flash' do
            put :toggle_admin, params
            expect(flash.alert).to match(/.+error.+/)
          end
        end

      end


      describe 'DELETE #destroy' do
        let!(:current_plp)       { create(:private_label_person, private_label: private_label) }

        context 'with a record in the current private label' do
          it 'fetches the record if it is in the current private label' do
            delete :destroy, id: current_plp.id
            expect(assigns[:private_label_person]).to eq(current_plp)
          end

          context 'and the record is deleted' do
            before(:each) do
              allow(PrivateLabelPerson).to receive(:find).with(current_plp.id.to_s).and_return(current_plp)
              allow(current_plp).to receive(:destroyed?).and_return(true)
            end

            it 'redirects to the index page' do
              delete :destroy, id: current_plp.id
              expect(response).to redirect_to(private_labels_admin_private_label_people_path)
            end

            it 'sets a success message for the user' do
              delete :destroy, id: current_plp.id
              expect(flash.notice).to match(/^The person has been removed from.+/)
            end
          end

          context 'and the record is not deleted' do
            before(:each) do
              allow(PrivateLabelPerson).to receive(:find).with(current_plp.id.to_s).and_return(current_plp)
              allow(current_plp).to receive(:destroyed?).and_return(false)
            end

            it 'redirects to the index page' do
              delete :destroy, id: current_plp.id
              expect(response).to redirect_to(private_labels_admin_private_label_people_path)
            end

            it 'sets an error message for the user' do
              delete :destroy, id: current_plp.id
              expect(flash.alert).to match(/^There was an error.+/)
            end
          end
        end

        context 'with a record outside of the current private label' do
          it 'raises a NotFound error' do
            other_plp = create(:private_label_person, private_label: other_private_label)
            expect { delete :destroy, id: other_plp.id }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

    end # RSpec.describe PrivateLabelPeopleController

  end   # Admin module
end     # PrivateLabels module
