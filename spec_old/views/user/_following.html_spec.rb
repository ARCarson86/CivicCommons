
require 'spec_helper'

describe "/user/_following.html.erb" do

  it "displays no subscriptions when there are no subscriptions" do
    render :partial => "/user/following", :locals => { :user_name => "Tom", :subscriptions => nil }
    rendered.should contain("Tom is just getting started") #have_tag('div#div-id')
  end

  it "displays subscriptions when there are subscriptions" do
    convo_subscription = FactoryGirl.build(:conversation_subscription)

    render :partial => "/user/following", :locals => { :user_name => "Tom", :subscriptions => [convo_subscription] }
    rendered.should contain(convo_subscription.title)
  end

end


