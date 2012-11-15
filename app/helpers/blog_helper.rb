module BlogHelper
  ##
  # Returns the truncated summary text for a blog post. 
  # This method performs an HTML-safe truncation, so any 
  # HTML elements defined in the text do not count against
  # the maximum character limit for the summary.
  #
  # The current maximum number of characters is 235.
  #
  # If the summary is less than the maximum number of characters,
  # then it is returned unchanged.  If the summary is nil, then
  # nil is returned.
  #
  # If the text is truncated, then an ellipsis is appended onto it.
  #
  # @param [ContentItem] blog_post The blog post to get
  #   the summary text from
  #
  # @return [String] The summary text from +blog_post+ 
  #   truncated to 235 characters.  
  def truncate_blog_summary(blog_post)
    return nil if blog_post.summary.nil?
    return truncate_html(blog_post.summary.html_safe, :length => 235)
  end

  ##
  # Returns the truncated title for a blog post.  It is a 
  # simple truncation to 68 characters, with an ellipsis
  # appended.
  #
  # If the title is less than or equal to 68 characters, then
  # it is returned unchanged.
  #
  # @param [ContentItem] blog_post The blog post to get the
  #   title from
  #
  # @return [String] The title from +blog_post+ truncated
  #   to 68 characters; returns nil if the title is nil
  def truncate_blog_title(blog_post)
    return nil if blog_post.title.nil?

    return blog_post.title.truncate(68)
  end

  def format_publish_date(date)
    date = date.published if date.is_a? ContentItem
    return date.strftime('%A, %B %d, %Y')
  end

  def blog_filter_by_author_link(author,current_author)
    if author == current_author
      path = blog_index_path(request.parameters.merge({:author_id => nil, :page => nil}))
    else
      path = blog_index_path(request.parameters.merge({:author_id => author.id, :page => nil}))
    end
    link_to raw("#{profile_image(author,16,  'mem-img')}<span>#{author.name}</span>"), path , :class => "#{'active' if current_author.try(:id) == author.id}"
  end
end
