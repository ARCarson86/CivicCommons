json.cache! [@conversation, @conversation.updated_at] do
  json.partial! 'api/v1/contributions/contribution', collection: @contributions, as: :contribution
end
