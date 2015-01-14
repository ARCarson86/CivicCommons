require 'cucumber/rspec/doubles'

Given /^I have contributed a comment:$/ do |content|

  # TODO: Replace Date.parse with Chronic.parse
  FactoryGirl.create(:comment,
                 content: content,
                 person: @current_person,
                 conversation: @conversation,
                 created_at: Date.parse("2010/10/10"))
end

Given /^I have contributed a video:$/ do |contribution|

  @contribution = FactoryGirl.build(:embedded_snippet,
                                person: @current_person,
                                conversation: @conversation,
                                created_at: Date.parse("2010/10/10"),
                                url: "http://www.youtube.com/watch?v=qq7nkbvn1Ic",
                                content: contribution)


  @contribution.stub(:embed_code_for_video) do |video_id|
    "<test_embed src='http://www.youtube.com/v/#{video_id}?fs=1&amp;hl=en_US'></test_embed>"
  end


  @contribution.save

end

Given /^I have contributed a suggestion:$/ do |content|
  FactoryGirl.create(:suggested_action,
                 content: content,
                 person: @current_person,
                 conversation: @conversation,
                 created_at: Date.parse("2010/10/10"))
end

Given /^I have contributed a question:$/ do |question|
  FactoryGirl.create(:question,
                 content: question,
                 person: @current_person,
                 conversation: @conversation,
                 created_at: Date.parse("2010/10/10"))
end


Given /^I have contributed a attached_file:$/ do |attached_file_comment|
  FactoryGirl.create(:attached_file,
                 content: attached_file_comment,
                 person: @current_person,
                 conversation: @conversation,
                 attachment: File.new(Rails.root + 'spec/fixtures/test_pdf.pdf'),
                 created_at: Date.parse("2010/10/10"))
end

Given /^I have contributed a image:$/ do |image_comment|
  FactoryGirl.create(:attached_file,
                 content: image_comment,
                 person: @current_person,
                 conversation: @conversation,
                 created_at: Date.parse("2010/10/10"))
end

Given /^I have contributed a link:$/ do |link_comment|
  FactoryGirl.create(:link,
                 content: link_comment,
                 person: @current_person,
                 conversation: @conversation,
                 created_at: Date.parse("2010/10/10"),
                 url: "http://www.yahoo.com")
end

Given /^I want (\d+) contributions per page$/ do |per_page|
  @per_page = per_page
end

