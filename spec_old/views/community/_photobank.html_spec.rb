require 'spec_helper'

describe "/community/_photobank.html.erb" do

  let(:personA) {FactoryGirl.build(:normal_person)}
  let(:personB) {FactoryGirl.build(:normal_person)}

  it "displays a linkable list of members of the site." do
    view.stub(:member_profile).with(:personA).and_return("person A profile image")
    view.stub(:member_profile).with(:personB).and_return("person B profile image")
    render :partial => "/community/photobank", :locals => { :members => [:personA, :personB] }
    rendered.should contain("person A profile image")
    rendered.should contain("person B profile image")
  end

end

