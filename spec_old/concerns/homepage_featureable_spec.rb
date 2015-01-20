require 'spec_helper'

[Conversation, Issue].each do |model|
  describe model do
    it { should have_one(:homepage_featured) }

    it 'responds to "featured?" showing status of attachment to a HomepageFeatured object' do
      instance = FactoryGirl.create(model.to_s.downcase)
      instance.featured?.should be_false
      FactoryGirl.create(:homepage_featured, homepage_featureable: instance)
      instance.reload.featured?.should be_true
    end

    it 'provides a Class method for finding all objects associated with HomepageFeatured' do
      instance1 = FactoryGirl.create(model.to_s.downcase)
      instance2 = FactoryGirl.create(model.to_s.downcase)
      FactoryGirl.create(model.to_s.downcase)
      FactoryGirl.create(:homepage_featured, homepage_featureable: instance1)
      FactoryGirl.create(:homepage_featured, homepage_featureable: instance2)
      model.featured.all.should == [instance1, instance2]
    end
  end
end
