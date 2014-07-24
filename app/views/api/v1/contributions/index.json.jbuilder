json.cache! [@conversation, @conversation.updated_at] do
  @contributions.each do |contribution|
    json.set! contribution.id do
      json.partial! 'api/v1/contributions/contribution', contribution: contribution
    end
  end
end
