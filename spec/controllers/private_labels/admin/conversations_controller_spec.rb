require 'rails_helper'

module PrivateLabels
  module Admin

    RSpec.describe ConversationsController do
      it { should be_a PrivateLabels::Admin::BaseController }

      let(:private_label)           { create(:private_label) }
      let(:other_private_label)     { create(:private_label) }
      let(:admin)                   { create(:confirmed_person) }
      let!(:conversation)           { create(:conversation, private_label: private_label) }
      let!(:other_conversation)     { create(:conversation, private_label: other_private_label) }
      let!(:civic_conversation)     { create(:conversation) }

      before(:each) do
        Swayze.current_private_label = private_label
        create(:private_label_person, private_label: private_label, person: admin, admin: true)
        sign_in(admin)
      end

      describe 'GET #index' do
        it 'fetches only the conversations for the current private label' do
          get :index
          expect(assigns[:conversations]).to match_array([conversation])
        end
      end

      describe 'GET #edit' do
        context 'with a conversation from the current private label' do
          it 'fetches the conversation' do
            get :edit, id: conversation.id
            expect(assigns[:conversation]).to eq(conversation)
          end
        end

        context 'with a conversation from another private label' do
          it 'raises a RecordNotFound error' do
            expect { get :edit, id: other_conversation.id }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context 'with a Civic Commons conversation' do
          it 'raises a RecordNotFound error' do
            expect { get :edit, id: civic_conversation.id }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      describe 'PUT #update' do
        let(:new_title)         { Faker::Lorem.sentence }
        let(:new_summary)       { Faker::Lorem.paragraph }
        let(:params)            { { title: new_title, summary: new_summary } }

        context 'with a conversation from the current private label' do
          it 'fetches the conversation' do
            put :update, id: conversation.id, conversation: params
            expect(assigns[:conversation]).to eq(conversation)
          end

          context 'and the record saves successfully' do
            before(:each) do
              allow(Conversation).to receive(:find).with(conversation.id.to_s).and_return(conversation)
              expect(conversation).to receive(:update_attributes).with(params).and_return(true).and_call_original
            end

            it 'updates the data in the record' do
              expect(conversation.title).not_to eq(new_title)
              expect(conversation.summary).not_to eq(new_summary)
              put :update, id: conversation.id, conversation: params

              expect(conversation.title).to eq(new_title)
              expect(conversation.summary).to eq(new_summary)
            end

            it 'saves the record' do
              put :update, id: conversation.id, conversation: params
              expect(conversation).not_to be_changed
            end

            it 'redirects to the index page' do
              put :update, id: conversation.id, conversation: params
              expect(response).to redirect_to(private_labels_admin_conversations_path)
            end

            it 'sets a success message for the user' do
              put :update, id: conversation.id, conversation: params
              expect(flash.notice).to match(/Conversation updated successfully/)
            end
          end

          context 'and the record does not save successfully' do
            before(:each) do
              allow(Conversation).to receive(:find).with(conversation.id.to_s).and_return(conversation)
              expect(conversation).to receive(:update_attributes).with(params).and_return(false)
            end

            it 'renders the edit form' do
              put :update, id: conversation.id, conversation: params
              expect(response).to render_template(:edit)
            end
          end
        end

        context 'with a conversation from another private label' do
          it 'raises a RecordNotFound error' do
            expect { put :update, id: other_conversation.id, conversation: conversation }.to raise_error(ActiveRecord::RecordNotFound) 
          end
        end

        context 'with a Civic Commons conversation' do
          it 'raises a RecordNotFound error' do
            expect { put :update, id: civic_conversation.id, conversation: conversation }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end


      describe 'GET #show' do
        context 'with a conversation from the current private label' do
          it 'fetches the conversation' do
            get :show, id: conversation.id
            expect(assigns[:conversation]).to eq(conversation)
          end

          it 'renders the proper template' do
            get :show, id: conversation.id
            expect(response).to render_template(:show)
          end
        end

        context 'with a conversation from another private label' do
          it 'raises a RecordNotFound error' do
            expect { get :show, id: other_conversation.id }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context 'with a Civic Commons conversation' do
          it 'raises a RecordNotFound error' do
            expect { get :show, id: civic_conversation.id }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      describe 'GET #new' do
        it 'creates a conversation in the current private label' do
          get :new
          expect(assigns[:conversation].private_label).to eq(private_label)
        end
      end

      describe 'POST #create' do
        let(:title)         { Faker::Lorem.sentence }
        let(:summary)       { Faker::Lorem.paragraph }
        let(:params)        { { title: title, summary: summary } }

        it 'saves the new object' do
          post :create, conversation: params
          new_convo = assigns[:conversation]
          expect(new_convo).not_to be_new_record
          expect(new_convo).to be_persisted
        end

        it 'creates a conversation with the user input' do
          post :create, conversation: params
          new_convo = assigns[:conversation]
          expect(new_convo.title).to eq(title)
          expect(new_convo.summary).to eq(summary)
        end

        it 'sets the private label on the new conversation to the current private label' do
          post :create, conversation: params
          expect(assigns[:conversation].private_label).to eq(private_label)
        end

        it 'sets the owner to the currently logged in admin' do
          post :create, conversation: params
          convo = assigns[:conversation]
          expect(convo.person).to eq(admin)
          expect(convo.owner).to eq(admin.id)
        end
      end
    
    end

  end # Admin module
end # PrivateLabels
