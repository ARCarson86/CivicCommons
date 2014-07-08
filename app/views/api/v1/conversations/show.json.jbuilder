json.(@conversation, :title, :starter, :summary, :created_at)

json.author do |json|
  json.partial! @conversation.person
end

json.number_of_top_level_contributions @conversation.top_level_contributions.count
json.number_of_contributions @conversation.contributions.count
