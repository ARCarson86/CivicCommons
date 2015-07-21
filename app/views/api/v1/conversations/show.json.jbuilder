json.(@conversation, :id, :slug, :title, :starter, :created_at, :link)

json.summary sanitize(auto_link(@conversation.summary, html: {target: "_blank"}, sanitize: false), tags: %w(strong em span p ul ol li a br), attributes: %w(href title target style))

json.panel_image image_url(@conversation.image.url(:panel))

json.author do |json|
  json.partial! @conversation.person
end

json.number_of_top_level_contributions @conversation.top_level_contributions.count
json.number_of_contributions @conversation.contributions.count
json.ratings @ratings
json.email_subject u email_share_subject(@conversation)
json.email_body @html_content.html_safe
json.conversation_url conversation_url(@conversation)
