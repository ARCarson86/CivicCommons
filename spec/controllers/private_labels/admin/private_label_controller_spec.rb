require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe PrivateLabelController do
      let(:private_label)           { create(:private_label) }
      let(:admin)                   { create(:confirmed_person) }

      before(:each) do
        Swayze.current_private_label = private_label
        create(:private_label_person, person: admin, private_label: private_label, admin: true)
        sign_in admin
      end

      it { should be_a PrivateLabels::Admin::BaseController }

      describe 'GET #show' do
        it 'renders the correct template' do
          get :show
          expect(response).to render_template(:show)
        end

        it 'gets the current private label' do
          get :show
          expect(assigns[:private_label]).to eq(private_label)
        end
      end

      describe 'GET #edit' do
        it 'renders the correct template' do
          get :edit
          expect(response).to render_template(:edit)
        end

        it 'gets the current private label' do
          get :edit
          expect(assigns[:private_label]).to eq(private_label)
        end
      end

      describe 'PUT #update' do
        let(:domain)      { Faker::Internet.url }
        let(:tagline)     { Faker::Company.catch_phrase }
        let(:email)       { Faker::Internet.email }
        let(:params)      { { domain: domain, email: email, tagline: tagline } }

        context 'when the private label is updated successfully' do
          it 'changes the values on the private label' do
            expect(private_label.domain).not_to eq(domain)
            expect(private_label.email).not_to eq(email)
            expect(private_label.tagline).not_to eq(tagline)

            put :update, private_label: params

            expect(private_label.domain).to eq(domain)
            expect(private_label.tagline).to eq(tagline)
            expect(private_label.email).to eq(email)
          end
          
          it 'saves the private label' do
            put :update, private_label: params
            expect(private_label).not_to be_changed
          end

          it 'redirects to the show settings page' do
            put :update, private_label: params
            expect(response).to redirect_to(private_labels_admin_private_label_path)
          end

          it 'provides a success message for the user' do
            put :update, private_label: params
            expect(flash.notice).to match(/updated successfully/)
          end
        end

        context 'when the private label is not updated successfully' do
          before(:each) do
            expect(private_label).to receive(:update_attributes).with(params).and_return(false)
          end

          it 'renders the edit template' do
            put :update, private_label: params
            expect(response).to render_template(:edit)
          end
        end
      end

    end

  end # Admin module
end   # PrivateLabels module 
