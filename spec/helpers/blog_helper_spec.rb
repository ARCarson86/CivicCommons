require 'spec_helper'
include AvatarHelper
describe BlogHelper do

  def mock_blog(attributes={})
    mock_model(ContentItem,{:content_type=>'BlogPost'}.merge(attributes)).as_null_object
  end

  describe "#blog_filter_by_author_link" do
    let(:author) do
      FactoryGirl.build(:person, 
                    :name => 'John Author', 
                    :id => 123,
                    :avatar_cached_image_url => 'avatar.jpg')
    end

    let(:other_author) do
      FactoryGirl.build(:person,
                    :name => 'Jane OtherAuthor',
                    :id => 456,
                    :avatar_cached_image_url => 'avatar.jpg')
    end

    context "when author is different from current author" do
      it 'should return an anchor element that includes the author_id as a query attribute' do
        helper.blog_filter_by_author_link(author,other_author).should == "<a href=\"/blog?author_id=123\" class=\"\"><img alt=\"John Author\" class=\"mem-img\" height=\"16\" src=\"/assets/avatar.jpg\" title=\"John Author\" width=\"16\" /><span>John Author</span></a>"
      end
    end

    context 'when author and current_author are the same' do
      it "should return an anchor element with the 'active' CSS class" do
        helper.blog_filter_by_author_link(author,author).should == "<a href=\"/blog\" class=\"active\"><img alt=\"John Author\" class=\"mem-img\" height=\"16\" src=\"/assets/avatar.jpg\" title=\"John Author\" width=\"16\" /><span>John Author</span></a>"
      end
    end
  end

  describe "#truncate_blog_summary" do
    let(:blog_post) { FactoryGirl.build(:blog_post, :summary => summary_text) }
    subject { helper.truncate_blog_summary(blog_post) }

    context "with a nil summary" do
      let(:summary_text) { nil }

      it { should be_nil }
    end

    context "with a summary of less than the maximum number of characters" do
      let(:summary_text) { "This is a summary that is shorter than the <strong>maximum</strong> so it should be the same" }

      it "returns the summary unchanged" do
        subject.should == summary_text
      end

      context "with HTML code" do
        let(:summary_text) { "Lorem <strong class=\"testing\">ipsum</strong> dolor sit amet, consectetur adipiscing elit. Etiam posuere adipiscing magna at interdum. Sed id nisl a metus consequat luctus. Aenean scelerisque nunc ut tortor tempus accumsan. Duis id nisl ut dolor rutrum massa nunc." }

        it "doesn't count the HTML towards the character count" do
          subject.should == summary_text
        end
      end
    end

    context "with a summary of more than the maxmimum number of characters" do
      let(:summary_text) { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent augue libero, auctor sed venenatis in, tempor vel neque. Nulla auctor quam quis orci accumsan ultricies. Phasellus facilisis, sem sit amet volutpat volutpat, lorem magna porta posuere." }

      it "truncates the summary text" do
        subject.length.should be <= 235
      end

      it "adds an ellipsis to the summary" do
        subject.should end_with('...')
      end

      context "with HTML that would be affected" do
        let(:summary_text) { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent augue libero, auctor sed venenatis in, tempor vel neque. Nulla auctor quam quis orci accumsan ultricies. Phasellus facilisis, sem sit amet volutpat volutpat, <strong class="testing">lorem magna porta posuere</strong>.' }

        it "closes the HTML element correctly" do
          expected = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent augue libero, auctor sed venenatis in, tempor vel neque. Nulla auctor quam quis orci accumsan ultricies. Phasellus facilisis, sem sit amet volutpat volutpat, <strong class="testing">lorem...</strong>'
          subject.should == expected
        end
      end
    end
  end
end
