require 'spec_helper'

describe UnsubscribeDigestController do

  it "generates and recognizes #unsubscribe_me" do
    { get: '/unsubscribe-me/1' }.should route_to(controller: 'unsubscribe_digest', action: 'unsubscribe_me', id: '1')
  end

  it "generates and recognizes #remove_from_digest" do
    { put: '/unsubscribe-me/1' }.should route_to(controller: 'unsubscribe_digest', action: 'remove_from_digest', id: '1')
  end

end
