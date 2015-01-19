# passing
require 'spec_helper'
require 'acceptance/support/facebookable'

describe Authentication do
  context "factories" do
    it 'should be valid' do
      FactoryGirl.build(:authentication).should be_valid
      FactoryGirl.create(:authentication).should be_valid
      FactoryGirl.build(:facebook_authentication).should be_valid
      FactoryGirl.create(:facebook_authentication).should be_valid
    end
  end

  context "Associations" do
    it "should only belongs to a Person" do
      Authentication.reflect_on_association(:person).macro == :belongs_to
    end
  end
  context "validations" do
    let(:blank_authentication) { Authentication.create }
    it "should not have blank uid" do
      blank_authentication.errors[:uid].first.should == "can't be blank"
    end
    it "should not have blank provider" do
      blank_authentication.errors[:provider].first.should == "can't be blank"
    end
    it "can only have one unique provider and uid at any given time" do
      auth1 = FactoryGirl.create(:authentication, :uid => '123',:provider => 'facebook')
      auth2 = FactoryGirl.build(:authentication, :uid => '123',:provider => 'facebook')
      auth2.valid?.should be_false
      auth2.errors[:uid].first.should == "has already been taken"
    end

  end
  context "omniauth" do
    before(:each) do
      include Facebookable
      facebookable = Class.new { include Facebookable }.new
      @auth_hash = facebookable.auth_hash
    end
    describe "building authentication model from omniauth hash" do
      def given_an_authentication_from_hash
        @authentication = Authentication.new_from_auth_hash(@auth_hash)
      end
      it "should have uid" do
        given_an_authentication_from_hash
        @authentication.uid.should == "12345"
      end
      it "should have provider" do
        given_an_authentication_from_hash
        @authentication.provider.should == 'facebook'
      end
      it "should find the authentication based on the hash" do
        given_an_authentication_from_hash
        @authentication.person_id = 1
        @authentication.save
        Authentication.find_from_auth_hash(@auth_hash).should == @authentication
      end
    end
  end

  context "email_from_auth_hash" do
    it "should return the email if it exists in the hash" do
      hash = {"info"=>{ "email"=>"johnd@test.com"}}
      Authentication.email_from_auth_hash(hash).should == 'johnd@test.com'
    end
    it "should return nil if it doesn't exist in the hash" do
      Authentication.email_from_auth_hash({}).should be_nil
    end
    it "should return nil if nil is put there" do
      Authentication.email_from_auth_hash(nil).should be_nil
    end

  end
end
