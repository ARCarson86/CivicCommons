module TopicsHelper
  def render_issue_topics_sidebar
    render 'topics/issue_topic_sidebar', :topics => @topics
  end

  def issue_topic_filter(topic)
    active = @current_topic == topic
    css_class = active ? 'active' : ''
    topic_id = active ? nil : topic.id
    link_to raw("<span>#{topic.name}</span> <em>#{topic.issue_count}</em>"), issues_path(:topic => topic_id), :class=> css_class
  end

  def conversation_topic_filter(topic)
    active = @current_topic == topic
    css_class = active ? 'active' : ''
    topic_id = active ? nil : topic.id
    link_to raw("<span>#{topic.name}</span> <em>#{topic.conversation_count}</em>"), conversations_path(:topic => topic_id), :class=> css_class
  end

  def render_blogpost_topics_sidebar
    render 'topics/blogpost_topic_sidebar', :topics => @topics
  end

  def content_item_topic_filter(topic, content_type)
    active = @current_topic == topic
    css_class = active ? 'active' : ''
    topic_id = active ? nil : topic.id

    case content_type
    when :blogpost
      path = blog_index_path(request.parameters.merge({:topic => topic_id, :page => nil}))
    else
      path = ''
    end

    link_to raw("<span>#{topic.name}</span> <em>#{topic.content_item_count}</em>"), path , :class=> css_class
  end

  def topics_one_line(obj)
    topics = obj.topics.collect{|topic|topic.name}
    if topics.present?
      "Topic: #{topics.to_sentence(:last_word_connector => ', ')}"
    else
      return nil
    end

  end

  def topics_list_for(obj)
    rendered_list = obj.topics.map do |topic|
      if obj.class == Issue
        render partial: "issues/issue_list_item", locals: { topic: topic }
      elsif obj.class == ContentItem and obj.content_type == 'BlogPost'
        render partial: "blog/blog_list_item", locals: { topic: topic }
      end
    end
    rendered_list.to_sentence(last_word_connector: ", ", two_words_connector: ", ").gsub(/\n/, "")
  end

end
