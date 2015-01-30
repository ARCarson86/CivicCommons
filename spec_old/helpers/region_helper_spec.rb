require 'spec_helper'

describe RegionHelper do
  context "default_region" do
    def stub_person(attributes={})
      @stub_person ||= stub_model(Person, attributes)
    end
    context "and no parameter is passed in" do
      describe "when signed in" do
        before(:each) do
          helper.stub!(:signed_in?).and_return(true)
        end
        it "should use the current_person's default region first as a first priority" do
          helper.stub!(:current_person).and_return(stub_person(:default_region => 1234))
          helper.default_region.should == 1234
        end
      end
      describe "when signed out" do
        before(:each) do
          helper.stub!(:signed_in?).and_return(false)
        end
        it "should use the cookie if the person's default region is not available" do
          helper.stub!(:current_person).and_return(stub_person)
          helper.request.cookies[:default_region] = "4321"
          helper.default_region.should == 4321
        end
      end
      it "should retun nil as a default region(metrocode)" do
        helper.stub!(:current_person).and_return(stub_person)
        helper.stub!(:signed_in?).and_return(false)
        helper.default_region.should == nil
      end
    end
    context "and a paramater is supplied" do
      it "should set the current person's default_region if signed in" do
        stub_person.should_receive(:set_default_region).and_return(12345)
        helper.stub!(:cookies).and_return(double('Cookie',:permanent=>{}))
        helper.stub!(:current_person).and_return(stub_person)
        helper.stub!(:signed_in?).and_return(true)
        
        helper.default_region(12345).should == 12345
      end
      it "should set the cookie" do
        stub_person.should_receive(:set_default_region).and_return(12345)
        cookie_double = double('Cookie')
        helper.stub!(:cookies).and_return(cookie_double)
        helper.stub!(:current_person).and_return(stub_person)
        helper.stub!(:signed_in?).and_return(true)
        cookie_double.should_receive(:permanent).and_return({})
        helper.default_region(12345).should == 12345
      end
    end
  end
end
