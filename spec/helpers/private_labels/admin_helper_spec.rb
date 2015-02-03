require 'rails_helper'

module PrivateLabels

  RSpec.describe AdminHelper do
    describe '#admin_sidebar_link_to' do
      let(:link_text)         { 'Some Text' }
      let(:path)              { Faker::Internet.url }
      let(:result)            { helper.admin_sidebar_link_to(link_text, path, Person) }
      let(:auth_obj)          { Person }

      context 'when the current user has permissions' do
        before(:each) do
          allow(helper).to receive(:can?).with(:manage, auth_obj).and_return(true)
        end

        it 'returns a string' do
          expect(result).to be_a String
        end

        it 'returns HTML to create a link within a list item' do
          expect(result).to match(/^<li class=""><a href="#{path}">#{link_text}<\/a><\/li>$/)
        end

        context 'when the page is the current page' do
          before(:each)         { allow(helper).to receive(:current_page?).with(path).and_return(true) }

          it 'adds the "active" css class to the link HTML' do
            expect(result).to match(/^<li class="active"><a href="#{path}">#{link_text}<\/a><\/li>/)
          end
        end
      end

      context 'when the current user does not have permissions' do
        before(:each) do
          allow(helper).to receive(:can?).with(:manage, auth_obj).and_return(false)
        end

        it 'returns nil' do
          expect(result).to be_nil
        end
      end
    end
  end

end # PrivateLabels module
