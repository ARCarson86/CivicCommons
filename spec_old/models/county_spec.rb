#passed
require 'spec_helper'

describe County do
  it "should not allow > 2 letter state names" do 
    invalid = County.new(:name=>"hello", :state=>"too long")
    invalid.save.should == false
  end
end
