class PrivateLabels::Contact < ActionMailer::Base
  layout 'plain_email'
  default from: "privatelabel@theciviccommons.com"

  def send_contact_email(message)
    @private_label = Swayze.current_private_label
    @message = message
    headers['X-SMTPAPI'] = '{"category": "private_label_contact"}'
    mail(subject: "Contact Us Submission On: #{@private_label.name}",
         from: "contactus@#{@private_label.domain}",
         to: @private_label.email)
  end
end
