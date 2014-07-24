json.cache! [@conversation, contribution, contribution.updated_at] do
  json.(contribution, :id, :content, :created_at, :parent_id)

  json.owner_id contribution.owner

  if contribution.parent_id.blank?
    json.contributions do |json|
      json.partial! 'api/v1/contributions/contribution', collection: contribution.descendants, as: :contribution
    end
  end
end
