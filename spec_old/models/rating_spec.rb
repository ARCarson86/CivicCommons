#passed
require 'spec_helper'

describe Rating do
  before(:each) do
    @current_person = FactoryGirl.create(:normal_person)
    @contribution = FactoryGirl.create(:comment)
    @descriptor = FactoryGirl.create(:rating_descriptor)
    @descriptor2 = FactoryGirl.create(:rating_descriptor, :title => "Motivating")
    @rg = FactoryGirl.create(:rating_group, :contribution => @contribution, :person => @current_person)
    @rating = FactoryGirl.create(:rating, :rating_group => @rg, :rating_descriptor => @descriptor)
    @rating2 = FactoryGirl.create(:rating, :rating_group => @rg, :rating_descriptor => @descriptor2)
    @rating1b = FactoryGirl.create(:rating, :rating_descriptor => @descriptor)
  end

  it "should have a descriptor" do
    @rating.rating_descriptor.title.should == "Inspiring"
  end

  it "should display the descriptor when using the title shortcut" do
    @rating.title.should == "Inspiring"
  end

end

