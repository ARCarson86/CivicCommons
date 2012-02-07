require 'spec_helper'

describe TopicsHelper do
  describe 'topics_list_for' do
    before(:each) do
      @topic = Factory.create(:topic)
    end

    context 'Issues' do
      context 'when there are no topics' do
        let(:issue_without_topic) { Factory.build(:issue, topics: []) }
        it "does not display topics" do
          topics_list_for(issue_without_topic).should eq ""
        end
      end

      context "when there is 1 topic" do
        let(:issue_with_topic) { Factory.build(:issue, topics: [@topic]) }

        it "displays just the one topic" do
          topics_list_for(issue_with_topic).should include @topic.name
        end
        it "makes that topic a link" do
          topics_list_for(issue_with_topic).should include '<a href="/issues?topic=' + @topic.id.to_s + '">' + @topic.name + '</a>'
        end
        it "encapsulates the link in the span with the data-topic-id" do
          topics_list_for(issue_with_topic).should include 'data-topic-id="' + @topic.id.to_s + '"'
        end
      end

      context "when there are more than one topic" do
        let(:issue_with_topics) do
          @topic2 = Factory.build(:topic)
          Factory.build(:issue, topics: [@topic, @topic2])
        end

        it "displays the topics comma seperated" do
          raw_text = strip_tags(topics_list_for(issue_with_topics))
          raw_text.squeeze(" ").should include @topic.name + ', ' + @topic2.name
        end
      end
    end

    context 'RadioShows' do
      context 'when there are no topics' do
        let(:radioshow_without_topic) { Factory.build(:radio_show, topics: []) }
        it "does not display topics" do
          topics_list_for(radioshow_without_topic).should eq ""
        end
      end

      context "when there is 1 topic" do
        let(:radioshow_with_topic) { Factory.build(:radio_show, topics: [@topic]) }

        it "displays just the one topic" do
          topics_list_for(radioshow_with_topic).should include @topic.name
        end
        it "makes that topic a link" do
          topics_list_for(radioshow_with_topic).should include '<a href="/radioshow?topic=' + @topic.id.to_s + '">' + @topic.name + '</a>'
        end
        it "encapsulates the link in the span with the data-topic-id" do
          topics_list_for(radioshow_with_topic).should include 'data-topic-id="' + @topic.id.to_s + '"'
        end
      end

      context "when there are more than one topic" do
        let(:radioshow_with_topics) do
          @topic2 = Factory.build(:topic)
          Factory.build(:radio_show, topics: [@topic, @topic2])
        end

        it "displays the topics comma seperated" do
          raw_text = strip_tags(topics_list_for(radioshow_with_topics))
          raw_text.squeeze(" ").should include @topic.name + ', ' + @topic2.name
        end
      end
    end
  end

  describe "render_issue_topics_sidebar" do
    it "should render the topic/issue_topic_sidebar" do
      @topics = 'topic-id'
      helper.should_receive(:render).with('topics/issue_topic_sidebar', :topics =>'topic-id')
      helper.render_issue_topics_sidebar#.with().render_issue_topics_sidebar.should_render_template 'render_issue_topics_sidebar'
    end
  end
  describe "issue_topic_filter" do
    before(:each) do
      @topic = mock(Topic,:issue_count => 1, :name => 'Topic One', :id => 1001)
      @current_topic = mock(Topic,:issue_count => 1, :name => 'Topic Two', :id => 1002)
    end
    it "should link to the topic" do
      issue_topic_filter(@topic).should include 'href="/issues?topic=1001"'
      issue_topic_filter(@topic).should include 'Topic One'
    end
    it "should have an 'active' class if the current topic has matched" do
      issue_topic_filter(@current_topic).should include 'class="active"'
    end
    it "should not have 'active' css class if the current topic has not match" do
      issue_topic_filter(@topic).should_not include "active"
    end
  end

  describe "render_radioshow_topics_sidebar" do
    it "should render the topic/radioshow_topic_sidebar" do
      @topics = 'topic-id'
      helper.should_receive(:render).with('topics/radioshow_topic_sidebar', :topics =>'topic-id')
      helper.render_radioshow_topics_sidebar
    end
  end
  describe "radioshow_topic_filter" do
    before(:each) do
      @topic = mock(Topic,:radioshow_count => 1, :name => 'Topic One', :id => 1001)
      @current_topic = mock(Topic,:radioshow_count => 1, :name => 'Topic Two', :id => 1002)
    end
    it "should link to the topic" do
      radioshow_topic_filter(@topic).should include 'href="/radioshow?topic=1001"'
      radioshow_topic_filter(@topic).should include 'Topic One'
    end
    it "should have an 'active' class if the current topic has matched" do
      radioshow_topic_filter(@current_topic).should include 'class="active"'
    end
    it "should not have 'active' css class if the current topic has not match" do
      radioshow_topic_filter(@topic).should_not include "active"
    end
  end
end
