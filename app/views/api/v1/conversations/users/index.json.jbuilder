json.cache! [@conversation, @conversation.updated_at, :users] do
  @users.each do |user|
    json.set! user.id do
      json.partial! 'api/v1/people/person', person: user
    end
  end
end
