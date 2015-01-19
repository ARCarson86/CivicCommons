require 'spec_helper'

describe MetroRegionsController do
  it "should call the default_region method" do
    @controller.should_receive(:default_region).and_return(123)
    post :filter, :metrocode => 1234
  end
  it "should redirect to :back" do
    self.stub!(:default_region).and_return(123)
    post :filter, :metrocode => 1234
    response.should redirect_to 'http://test.host/conversations'
  end

end
