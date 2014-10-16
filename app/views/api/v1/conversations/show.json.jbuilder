json.(@conversation, :id, :slug, :title, :starter, :created_at)

json.summary sanitize(auto_link(@conversation.summary, html: {target: "_blank"}, sanitize: false), tags: %w(strong em span p ul ol li a), attributes: %w(href title target style))

json.author do |json|
  json.partial! @conversation.person
end

json.number_of_top_level_contributions @conversation.top_level_contributions.count
json.number_of_contributions @conversation.contributions.count
