require 'rails_helper.rb' 

RSpec.describe FactoryGirl do
  describe 'Factory Girl' do
    it 'lints factories successfully' do
      expect{ FactoryGirl.lint }.not_to raise_error
    end
  end
end
