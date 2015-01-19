require 'spec_helper'

describe Admin::DashboardController do
  context "showing with an admin logged in" do

    before :each do
      @admin_person = FactoryGirl.create(:admin_person)
      @controller.stub(:current_person).and_return(@admin_person)
      Socket.stub(:gethostname).and_return('YOUR MOM GOES TO COLLEGE')
      get :show
    end

    it "renders show action" do
      response.should render_template('dashboard/show')    
    end
    it 'sets the hostname' do
      assigns(:host).should == 'YOUR MOM GOES TO COLLEGE'
    end

  end
end
