require 'rails_helper'

module PrivateLabels
  module Admin
    RSpec.describe PagesController, :type => :controller do
      it { should be_a PrivateLabels::Admin::BaseController }

      let(:private_label)            { create(:private_label) }
      let(:admin)                    { create(:confirmed_person) }
      let(:new_page)                 { private_label.pages.build }
      let(:restricted_private_label) { create(:private_label) }
      let!(:page_1)                  { create(:page, private_label: private_label) }
      let!(:page_2)                  { create(:page, private_label: private_label) }
      let!(:restricted_page)         { create(:page, private_label: restricted_private_label) }

      before(:each) do
        Swayze.current_private_label = private_label
        create(:private_label_person, person: admin, private_label: private_label, admin: true)
        sign_in admin
      end

      context 'GET #index' do
        it 'fetches the pages for the current private label' do
          get 'index'
          expect(assigns[:pages]).to eq([page_1, page_2])
        end
      end

      context 'GET #new' do
        it 'gets a new Page object' do
          get 'new'
          expect(assigns[:page].attributes).to eq(new_page.attributes)
        end
      end

      context 'POST #create' do
        before(:each) do
          post 'create', page: page_params
        end
        describe 'with valid page parameters' do
          let(:page_params) { { title: "Test Page", content: "Lorem Ipsum" } }
          it 'creates a new page object from the passed parameters' do
            expect(assigns[:page]).to be_persisted
            expect(assigns[:page].title).to eq(page_params[:title])
            expect(assigns[:page].content).to eq(page_params[:content])
            expect(assigns[:page].slug).to eq("test-page")
            expect(response).to redirect_to private_labels_admin_pages_path
          end
        end
        describe 'with missing title' do
          let(:page_params) { { title: "", content: "Lorem Ipsum" } }
          it "doesn't create the new object" do
            expect(assigns[:page]).not_to be_persisted
            expect(assigns[:page].errors.size).to eq(1)
            expect(response).to render_template(:new)
          end
        end
      end

      context 'GET #edit' do
        it "gets the specified Page object for editing" do
          get 'edit', id: page_1.id
          expect(assigns[:page]).to eq(page_1)
        end
      end

      context 'PUT #update' do

        describe 'with an invalid id' do
          specify { expect { put 'update', id: restricted_page.id, page: {} }.to raise_error(ActiveRecord::RecordNotFound) }
        end

        describe 'with a valid page id' do

          before(:each) do
            put 'update', id: page_1.id, page: page_params
          end

          describe 'with a new title' do
            let(:page_params) { { title: "Updated Title" } }
            it 'updates the page with the specified parameters' do
              expect(assigns[:page].title).to eq(page_params[:title])
              expect(page_1.reload.title).to eq(page_params[:title])
            end
          end

          describe 'with a blank title' do
            let(:page_params) { { title: "" } }
            it 'updates the page with the specified parameters' do
              expect(assigns[:page].errors.size).to eq(1)
              expect(response).to render_template(:edit)
            end
          end

        end
      end

      context 'GET #show' do

        describe 'with an invalid id' do
          specify { expect { get 'show', id: restricted_page.id }.to raise_error(ActiveRecord::RecordNotFound) }
        end

        describe 'with a valid page id' do
          before(:each) do
            get 'show', id: page_1.id
          end
          specify { expect(response).to render_template(:edit) }
        end
      end

      context 'DELETE #destroy' do
        describe 'with an invalid id' do
          specify { expect { delete 'destroy', id: restricted_page.id }.to raise_error(ActiveRecord::RecordNotFound) }
        end

        describe 'with a valid page id' do
          before(:each) do
            delete 'destroy', id: page_1.id
          end
          it 'destroys the page' do
            expect(assigns[:page]).to be_destroyed
            expect(response).to redirect_to(private_labels_admin_pages_path)
          end
        end

      end

    end

  end # Admin module
end # PrivateLabels module
