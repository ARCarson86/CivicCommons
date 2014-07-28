json.(contribution, :id, :content, :created_at, :parent_id)

json.owner_id contribution.owner

if contribution.parent_id.blank?
  json.set! :contributions do
    json.partial! 'api/v1/conversations/contributions/contribution', collection: contribution.descendants, as: :contribution
  end
end
