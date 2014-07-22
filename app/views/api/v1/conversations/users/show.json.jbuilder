json.cache! [@conversation, @conversation.updated_at, @user] do
  json.partial! 'api/v1/people/person', person: @user
end
