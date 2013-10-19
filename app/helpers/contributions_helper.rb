module ContributionsHelper
  def contribution_parent_page(contribution)
    if contribution.conversation
      conversation_path(contribution.conversation)
    else
      issue_path(contribution.issue)
    end
  end

  def person_display_name(person)
    if person
      text_profile(person).html_safe
    else
      'An unknown person'
    end
  end

  def link_to_edit_contribution(contribution,options= {})
    link_to edit_conversation_contribution_path(contribution.conversation, contribution),
      options.merge({
        :remote => true,
        :method => :get,
        :class => "edit-contribution-action",
        :id => "edit-#{contribution.id}",
        'data-target' => "#show-contribution-#{contribution.id}",
        'data-type' => 'html'}
      ) do
        yield if block_given?
        "Edit"
      end
  end
end
