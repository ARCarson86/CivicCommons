require 'spec_helper'
include AvatarHelper
describe RadioshowHelper do
  
  def mock_radioshow(attributes={})
    @radioshow ||= mock_model(ContentItem,{:content_type=>'RadioShow'}.merge(attributes)).as_null_object
  end
  def mock_person(attributes={})
    mock_model(Person,attributes).as_null_object
  end
  describe "radioshow_hosts" do
    it "should return the correct sentence of radioshow" do
      person = mock_person(:name=>'John Doe',:id => 123)
      @radioshow = mock_radioshow(:hosts => [person])
      helper.radioshow_hosts(@radioshow).should == "<p><strong>Hosted by:</strong>&nbsp;<a href=\"http://test.host/user/123\" title=\"John Doe\">John Doe</a>"
    end
    it "should have 'and' between hosts" do
      person1 = mock_person(:name=>'John Doe',:id => 123)
      person2 = mock_person(:name=>'John Doe',:id => 1234)
      @radioshow = mock_radioshow(:hosts => [person1, person2])
      helper.radioshow_hosts(@radioshow).should == "<p><strong>Hosted by:</strong>&nbsp;<a href=\"http://test.host/user/123\" title=\"John Doe\">John Doe</a> and <a href=\"http://test.host/user/1234\" title=\"John Doe\">John Doe</a>"
    end
  end
  describe "radioshow_guests" do
    it "should return the correct sentence of radioshow" do
      person = mock_person(:name=>'John Doe',:id => 123)
      @radioshow = mock_radioshow(:guests => [person])
      helper.radioshow_guests(@radioshow).should == "<p><strong>Special Guest:</strong>&nbsp;<a href=\"http://test.host/user/123\" title=\"John Doe\">John Doe</a>"
    end
    it "should have 'and' between guests" do
      person1 = mock_person(:name=>'John Doe',:id => 123)
      person2 = mock_person(:name=>'John Doe',:id => 1234)
      @radioshow = mock_radioshow(:guests => [person1, person2])
      helper.radioshow_guests(@radioshow).should == "<p><strong>Special Guest:</strong>&nbsp;<a href=\"http://test.host/user/123\" title=\"John Doe\">John Doe</a> and <a href=\"http://test.host/user/1234\" title=\"John Doe\">John Doe</a>"
    end
  end

end
