#passed
require 'spec_helper'

describe HomepageFeatured do
  it { should belong_to(:homepage_featureable) }
  it { should have_db_index([:homepage_featureable_id, :homepage_featureable_type]).unique(true) }
  it { should validate_presence_of(:homepage_featureable_id) }
  it { should validate_presence_of(:homepage_featureable_type) }

  describe 'factories' do
    it 'is valid' do
      FactoryGirl.build(:homepage_featured).should be_valid
      FactoryGirl.create(:homepage_featured).should be_valid
    end
  end

  describe 'creation' do
    it 'should not allow entries with duplicate homepage_featureable' do
      FactoryGirl.create(:homepage_featured)
      should validate_uniqueness_of(:homepage_featureable_id).scoped_to(:homepage_featureable_type)
    end
  end

  describe 'deletion' do
    it 'should not delete the homepage_featureable object if the HomepageFeature object is deleted' do
      homepage_featured = FactoryGirl.create(:homepage_featured)
      homepage_featureable = homepage_featured.homepage_featureable
      homepage_featured.destroy
      homepage_featureable.reload.should be_valid
    end
  end

  describe 'sample_and_filtered' do
    let(:homepage_featured) {FactoryGirl.create(:homepage_featured)}
    let(:homepage_featured2) {FactoryGirl.create(:homepage_featured)}
    let(:homepage_featured3) {FactoryGirl.create(:homepage_featured)}

    before(:each) do
      HomepageFeatured.stub(:all).and_return([homepage_featured2, homepage_featured, homepage_featured3])
    end

    it 'returns a sample of results' do
      hpf = HomepageFeatured.sample_and_filtered(2)

      sample_count = 0
      sample_count += 1 if hpf.include?(homepage_featured.homepage_featureable)
      sample_count += 1 if hpf.include?(homepage_featured2.homepage_featureable)
      sample_count += 1 if hpf.include?(homepage_featured3.homepage_featureable)

      sample_count.should == 2
    end

    it 'filters out a result' do
      hpf = HomepageFeatured.sample_and_filtered(2, homepage_featured2.homepage_featureable)

      hpf.include?(homepage_featured.homepage_featureable).should be_true
      hpf.include?(homepage_featured2.homepage_featureable).should be_false
      hpf.include?(homepage_featured3.homepage_featureable).should be_true
    end

    it 'filters out an array of results' do
      hpf = HomepageFeatured.sample_and_filtered(2, [homepage_featured.homepage_featureable, homepage_featured2.homepage_featureable])

      hpf.include?(homepage_featured.homepage_featureable).should be_false
      hpf.include?(homepage_featured2.homepage_featureable).should be_false
      hpf.include?(homepage_featured3.homepage_featureable).should be_true
    end
  end
end

