module ApplicationHelper
  # Meta Information Helpers
  def page_title
    @meta_info && !@meta_info[:page_title].blank? ? @meta_info[:page_title].chomp : "The Civic Commons"
  end

  def meta_description
    @meta_info && !@meta_info[:meta_description].blank? ? @meta_info[:meta_description].chomp : "The Civic Commons is a new way to bring communities together with conversation and emerging technology. We are focused on building conversations and connections that have the power to become informed, productive collective civic action."
  end

  def meta_keywords
    @meta_info && !@meta_info[:meta_tags].blank? ? @meta_info[:meta_tags].chomp : "community, conversation, civic action"
  end

  def show_errors(model)
    rv = ""
    all_errors = model.errors.full_messages
    if all_errors.any?
      rv = "<div id=\"error_explanation\"><h2>#{pluralize(all_errors.size, "error")} prohibited this #{model.class.to_s.downcase} from being saved:</h2><ul>"
      all_errors.each do |msg|
        rv = rv +"<li>#{msg}</li>"
      end
      rv = rv + "</ul></div"
    end
    rv.html_safe
  end

  def can_edit?(owner)
    return false if current_person.nil?

    return true if (current_person.admin || current_person == owner)
  end

  def paginated_showing_info(collection, name_of_collection)
    "Showing %s of %s"%[collection.count,
                        pluralize(collection.total_entries, name_of_collection)]
  end

  def nl2br(string)
    string.gsub(/\n/, '<br />') if string
  end

  def url_for(options = nil)
    if Hash === options
      # change all links to use 'http' protocol unless specified
      options[:protocol] ||= 'http'
    end
    super(options)
  end

  def contribution_item_url(contribution)
    if contribution.issue
      issue_url( contribution.item )
    elsif contribution.conversation
      conversation_url( contribution.item )
    end
  end

  def pluralize_without_count(count, singular, plural=nil, options={})
    plural = pluralize count, singular, plural
    plural.gsub(/\d+ /, "")
  end

  def cc_widget_embed_code(src_path, dom_id ='')
    src_path
    dom_id ||= 'civic-commons-widget'
    render :partial => '/widgets/cc_widget_embed_code', :locals => {:src_path => src_path, :dom_id => dom_id}
  end

  def asset_url(asset)
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end

  def mailer_asset_url(asset)
    base_url = root_url.to_s.gsub(/\/$/i,'')
    base_url + asset_path(asset)
  end

  def conversation_edit_link(conversation)
    edit_link = ""
    if current_person && current_person.admin?
      edit_link << '<span class="edit_conversation_link_admin">'
      edit_link << "- #{ link_to "<i class=\"icon-edit\"></i> Edit".html_safe, edit_conversation_path(@conversation) }"
      edit_link << '</span>'
    end
    edit_link.html_safe
  end

  # Determine if we should display the Regions Filter Tab
  #
  # since the conversations/filter doesn't exist, we wrap it all with a begin/rescue
  def show_regions_filter_tab?
    begin
      if current_page?(:controller => :conversations, :action => :index) ||
        current_page?(:controller => :issues, :action => :index) ||
        current_page?(:controller => :projects, :action => :index) ||
        current_page?(:controller => :search, :action => :results) ||
        current_page?(:controller => :conversations, :action => :filter)
        true
      else
        false
      end
    rescue
      false
    end
  end
end
