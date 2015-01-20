$LOAD_PATH << "."
require 'spec/fast/helper.rb'
require 'delegate'
require 'app/presenters/profile_presenter'
describe ProfilePresenter do

  let(:most_recent_activity) { stub(paginate: [1,2,3]) }

  let(:subscribed_issues) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] }
  let(:subscribed_conversations) { [:a,:b,:c,:d,:e,:f,:g,:h,:i,:j,:k] }
  let(:subscribed_organizations) { [:woof, :yap, :nnn, :ruff, :bowwow, :zzzz, :rrowff, :aaaooo, :raow, :mrow] }

  let(:user) do
    stub subscribed_issues: subscribed_issues,
      subscribed_conversations: subscribed_conversations,
      subscribed_organizations: subscribed_organizations,
      most_recent_activity: most_recent_activity,
      slug: "bob",
      name: "Bob"
  end
  let(:presenter) { ProfilePresenter.new(user, page: 1) }

  describe "#profile_data" do
    context "without an address" do
      subject { ProfilePresenter.new(stub_person(organization_detail: stub_organization_detail)).profile_data }
      it { should_not have_key :address  }
    end
    context "with an address" do
      let(:organization_detail) do
        stub_organization_detail(
          has_address?: true,
          street: '1530 Corunna Ave',
          city: 'Owosso',
          region: 'MI',
          postal_code: '48867'
        )
      end
      subject { ProfilePresenter.new(stub_person(organization_detail: organization_detail)).profile_data }
      it "forms the address cleanly" do
        subject[:address].should =~ /1530 Corunna Ave/
        subject[:address].should =~ /Owosso, MI 48867/
      end
    end
    context "with a facebook profile" do
      subject { ProfilePresenter.new(stub_person(organization_detail: stub_organization_detail(facebook_page: 'http://facebook.com'))).profile_data }
      it { should have_key :facebook }
    end
    context "with a phone number" do
      subject { ProfilePresenter.new(stub_person(organization_detail: stub_organization_detail(phone: "1-234-567"))).profile_data }
      it { should have_key :phone }
    end
    context "with twitter" do
      subject { ProfilePresenter.new(stub_person(twitter_username: 'asdf', organization_detail: stub_organization_detail)).profile_data }
      it { should have_key :twitter }
    end
    context "with email for an organization" do
      subject { ProfilePresenter.new(stub_person(email: 'email@example.com', organization_detail: stub_organization_detail, is_organization?: true)).profile_data }
      it { should have_key :email }
    end
    context "with email for a person" do
      subject { ProfilePresenter.new(stub_person(email: 'email@example.com', organization_detail: stub_organization_detail, is_organization?: false)).profile_data }
      it { should_not have_key :email }
    end
  end

  context "as an organization" do
    subject { ProfilePresenter.new(stub(is_organization?: true)) }
    it "has Our for possessive pronoun" do
      subject.possessive_pronoun.should == "Our"
    end
    it "has We Are for action phrase" do
      subject.action_phrase.should == "We Are"
    end
  end

  context "as an individual" do
    subject { ProfilePresenter.new(stub(is_organization?: false)) }
    it "has My for possessive pronoun" do
      subject.possessive_pronoun.should == "My"
    end
    it "has I Am for action phrase" do
      subject.action_phrase.should == "I Am"
    end
  end

  it "#has_issue_subscriptions?" do
    presenter.has_issue_subscriptions?.should_not be_nil
  end

  describe "#issue_subscriptions" do
    it "limits to 10" do
      presenter.issue_subscriptions.length.should == 10
    end
  end

  it "#has_conversation_subscriptions?" do
    presenter.has_conversation_subscriptions?.should_not be_nil
  end

  describe "#organization_subscriptions" do
    it "limits to 10 items" do
      presenter.organization_subscriptions.size.should == 10
    end
  end

  describe "#conversation_subscriptions" do
    it "limits to 10 items" do
      presenter.conversation_subscriptions.size.should == 10
    end
  end

  it "#has_recent_activities?" do
    presenter.has_recent_activities?.should_not be_nil
  end

  describe "#recent_activity" do
    it "is paginated" do
      presenter.recent_activity
      most_recent_activity.should have_received(:paginate).with(page: 1, per_page: 10)
    end
  end

  describe "#all_recent_activity" do
    it "is not paginated" do
      presenter.all_recent_activity
      most_recent_activity.should_not have_received(:paginate)
    end
  end

  describe "#feed_path" do
    it "is /user_path/user_slug.xml" do
      presenter.stub(:user_path) { |u, opts| "/user/#{u}.#{opts[:format]}" }
      presenter.feed_path.should == "/user/bob.xml"
    end
  end

  describe "#website" do
    context "without a prefix" do
      subject { ProfilePresenter.new(stub(website: 'google.com')).website }
      it { should == 'http://google.com' }
    end
    context "with a prefix" do
      subject { ProfilePresenter.new(stub(website: 'http://google.com')).website }
      it { should == 'http://google.com' }
    end
    context "no website" do
      subject { ProfilePresenter.new(stub(website: '')).website }
      it { should == '' }
    end
  end
  describe "#has_email?" do
    context "as an individual" do
      subject { ProfilePresenter.new(stub({is_organization?: false})) }
      it "should be false if it is an individual" do
        subject.has_email?.should be_false
      end
    end
    context "as an organization" do
      subject { ProfilePresenter.new(stub({is_organization?: true})) }
      it "should be true if it is an organization", :pending=>true do
        subject.has_email?.should be_true
      end
    end
  end

  describe "#feed_title" do
    it "is Name at The Civic Commons" do
      presenter.feed_title.should == "Bob at The Civic Commons"
    end
  end

  describe "#needs_to_fill_out_bio?" do
    context "when it is a different user" do
      let(:different_user) { stub() }
      it "is false" do
        presenter.prompt_to_fill_out_bio?(different_user).should == false
      end
    end
    context "when the same user" do
      context "bio is empty" do
        let(:same_user) { stub(:== => true) }
        let(:presenter) { ProfilePresenter.new stub(bio: stub(present?: false)) }
        it "is false" do
          presenter.prompt_to_fill_out_bio?(same_user).should == true
        end
      end
    end
  end

  describe "#has_profile?" do
    context "without a anything" do
      subject { ProfilePresenter.new stub_person }
      it { should_not have_profile }
    end
    context "with a website" do
      subject { ProfilePresenter.new stub_person(has_website?: true) }
      it { should have_profile }
    end
    context "with twitter" do
      subject { ProfilePresenter.new stub_person(has_twitter?: true) }
      it { should have_profile }
    end
    context "with address" do
      subject { ProfilePresenter.new stub_person(organization_detail: stub_organization_detail(has_address?: true )) }
      it { should have_profile }
    end
    context "with email" do
      context "is an individual" do
        subject { ProfilePresenter.new stub_person(has_email?: true ) }
        it { should_not have_profile }
      end
      context "is an organization" do
        subject { ProfilePresenter.new stub_person(has_email?: true, is_organization?: true ) }
        it { should have_profile }
      end
    end
  end
  describe "title" do
    context "when a person" do
      subject { ProfilePresenter.new stub_person(:title=>'abc') }
      it { subject.title.should == 'abc' }
    end
    context "with an organization" do
      subject { ProfilePresenter.new stub_person(:is_organization? => true) }
      it { subject.title.should be_nil }
    end
  end

  def stub_person options={}
    defaults = {
      organization_detail: nil,
      is_organization?: false,
      has_twitter?: false,
      has_website?: false,
      has_email?: false,
      twitter_username: "",
      website: "",
      email: ''
    }
    stub defaults.merge(options)
  end

  def stub_organization_detail options={}
    defaults = { present?: true, has_address?: false,
      facebook_page: '',
      phone: '' }
    stub defaults.merge(options)
  end
end
