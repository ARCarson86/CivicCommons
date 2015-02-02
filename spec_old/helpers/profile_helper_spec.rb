$LOAD_PATH << '.'
require 'app/helpers/profile_helper'
class TestProfileHelper
  include ProfileHelper
  def link_to body, url
    "<a href=\"#{url}\">#{body}</a>"
  end
end
describe ProfileHelper do
  let(:helper) { TestProfileHelper.new }
  describe "#contact_info" do
    subject do
      helper.contact_info_for(stub(profile_data: {
        address: "615 W King\nOwosso, MI"
      }))
    end
    it { should include "615 W King<br />Owosso, MI" }
    context "when it has empty stuff" do
      subject { helper.contact_info_for(stub(profile_data: { address: "" })) }
      it { should == "" }
    end
    context "with an address" do
      subject { helper.contact_info_for(stub(profile_data: { address: '1234, west south street' })) }
      it { should include "1234, west south street" }
    end
    context "with a website" do
      subject { helper.contact_info_for(stub(profile_data: { website: "http://www.google.com/" })) }
      it { should include "<a href=\"http://www.google.com/\">http://www.google.com/</a>" }
    end
    context "with a phone number" do
      subject { helper.contact_info_for(stub(profile_data: { phone: "1-234-567-8901" })) }
      it { should include "P: 1-234-567-8901" }
    end
    context "with address, phone number and website" do
      subject { helper.contact_info_for(stub(profile_data: {
                          phone: "1234",
                          address: "615 W King St, Owosso MI 48867",
                          website: "http://www.zacharyspencer.com"
                        }))
     }
     it { should == "<li class=\"website-profile\">615 W King St, Owosso MI 48867<br />P: 1234<br /><a href=\"http://www.zacharyspencer.com\">http://www.zacharyspencer.com</a></li>" }
    end
    context "with a twitter profile" do
      subject { helper.contact_info_for(stub(profile_data: { twitter: "1234" })) }
      it { should include "<li class=\"twitter-profile\"><a href=\"http://twitter.com/#!/1234\">@1234</a></li>" }
    end
    context "with a facebook profile" do
      subject { helper.contact_info_for(stub(profile_data: { facebook: "http://facebook.com/" })) }
      it { should include "<li class=\"fb-profile\"><a href=\"http://facebook.com/\">Facebook</a></li>" }
    end
    context "with an email and being an organization" do
      subject { helper.contact_info_for(stub(profile_data: { email: "email@example.com" })) }
      it { should include "<li class=\"email-profile\"><a href=\"mailto:email@example.com\">email@example.com</a></li>" }
    end
  end
end
