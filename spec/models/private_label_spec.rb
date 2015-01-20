require 'rails_helper'

describe PrivateLabel, :type => :model do
  before(:each) do
    stub_request(:post, "http://localhost:8981/solr/update?wt=ruby").
      with(:headers => {'Content-Type'=>'text/xml'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, /.*gravatar.com\/avatar\/.*/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'gravatar.com', 'User-Agent'=>'Ruby'}).
      to_return(:status => 404, :body => "", :headers => {})
  end

  let(:private_label) { FactoryGirl.create :private_label }
  let(:admin) { FactoryGirl.create :normal_person }

  describe "add_admin" do
    it "adds a person as a private label administrator" do
      private_label.add_admin admin
      expect(private_label.reload.admins).to include(admin)
    end
  end
end
