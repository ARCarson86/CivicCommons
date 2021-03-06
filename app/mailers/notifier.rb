class Notifier < Devise::Mailer

  layout 'mailer'
  add_template_helper(ConversationsHelper)
  add_template_helper(SurveysHelper)
  add_template_helper(ApplicationHelper)

  prepend_view_path "app/views/notifier"

  def email_changed(old_email, new_email)
    @old_email = old_email
    @new_email = new_email
    headers['X-SMTPAPI'] = '{"category": "email_changed"}'
    mail(:subject => "You've recently changed your email with The Civic Commons",
         :from => Devise.mailer_sender,
         :to => [old_email, new_email])
  end

  def welcome(record)
    @resource = record
    headers['X-SMTPAPI'] = '{"category": "welcome"}'
    mail(:subject => "Welcome to The Civic Commons",
         :from => Devise.mailer_sender,
         :to => @resource.email)
  end

  def new_registration_notification(record)
    @resource = record
    headers['X-SMTPAPI'] = '{"category": "new_registration_notification"}'
    mail(:subject => "New User Registered",
         :from => Devise.mailer_sender,
         :to => 'register@theciviccommons.com')
  end

  def suggestion_thank_you(record)
    @resource = record
    headers['X-SMTPAPI'] = '{"category": "suggestion_thank_you"}'
    mail(:subject => "Thank you for your suggestion",
         :from => Devise.mailer_sender,
         :to => @resource.email)
  end

  def invite_to_conversation(resource)
    @resource = resource
    @user = @resource[:user]
    @conversation = @resource[:conversation]
    headers['X-SMTPAPI'] = '{"category": "invite_to_conversation"}'
    mail(:subject => @user.name + " wants to invite you to a conversation at The Civic Commons",
         :from => Devise.mailer_sender,
         :to => @resource[:emails])
  end

  def violation_complaint(resource)
    @resource = resource
    @user = @resource[:user]
    @reason = @resource[:reason]
    @contribution = @resource[:contribution]
    headers['X-SMTPAPI'] = '{"category": "violation_complaint"}'
    mail(:subject => "ALERT: Possible TOS Violation reported",
         :from => Devise.mailer_sender,
         :to => Civiccommons::Config.email["default_email"])
  end

  def daily_digest(recipient, notifications, conversations)
    @recipient = recipient
    @notifications = notifications
    @conversations = conversations
    headers['X-SMTPAPI'] = '{"category": "daily_digest"}'
    mail(:subject => "Activity on The Civic Commons",
         :from => '"Curator of Conversation" <curator@theciviccommons.com>',
         :to => @recipient.email)
  end

  def survey_confirmation(survey_response)
    @person = survey_response.person
    @survey = survey_response.survey
    @selected_survey_option_titles = survey_response.selected_survey_option_titles
    headers['X-SMTPAPI'] = '{"category": "survey_confirmation"}'
    mail(:subject => "Thanks for your #{@survey.type.to_s.downcase} participation.",:from => Devise.mailer_sender,:to => @person.email) do |format|
      format.html do
        if @survey.is_a?(Vote)
          render :template => '/notifier/survey_vote_confirmation'
        end
      end
    end
  end

  def survey_ended(person, survey)
    @person = person
    @survey = survey
    headers['X-SMTPAPI'] = '{"category": "survey_ended"}'
    mail(:subject => "Check out the results of the \"#{survey.title}\" #{@survey.type.to_s.downcase}!",:from => Devise.mailer_sender,:to => @person.email) do |format|
      format.html do
        if @survey.is_a?(Vote)
          render :template => '/notifier/survey_vote_ended'
        end
      end
    end
  end

  def mentioned_notification(recipient, notification)
    @recipient = recipient
    @notification = notification

    mail(:subject => "#{@notification.person.name} tagged you in a Conversation at The Civic Commons!",
         :from => '"Curator of Conversation" <curator@theciviccommons.com>',
         :to => @recipient.email)

  end

  def products_services_promo(name, email, question, product = '')
    @name = name
    @email = email
    @question = question
    @product = product

    headers['X-SMTPAPI'] = '{"category": "products_services_promo"}'
    mail(:subject => "Engagement Services Form Request from #{name} #{product.present? ? ('about '+ product) : ''}",
         :from => email,
         :to => Civiccommons::Config.email["products_services_email"])
  end

  def other_conversation_topic_selected(conversation)
    @resource = conversation
    headers['X-SMTPAPI'] = '{"category": "other_conversation_topic_selected"}'
    mail(:subject => "A conversation has been created with Other Topic selected",
         :from => Devise.mailer_sender,
         :to => 'suggestions@theciviccommons.com')
  end

  def to_partial_path
    return "app/view/notifier"
  end
end
