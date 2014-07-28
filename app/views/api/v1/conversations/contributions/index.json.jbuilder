json.cache! [@conversation, @conversation.updated_at] do
  json.partial! 'api/v1/conversations/contributions/contributions', contributions: @contributions
end
