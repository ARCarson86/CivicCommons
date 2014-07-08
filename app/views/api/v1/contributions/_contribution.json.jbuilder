json.(contribution, :id, :content, :created_at)

json.author do |json|
  json.partial! contribution.person
end

json.conrtibutions do |json|
  json.partial! 'api/v1/contributions/contribution', collection: contribution.descendants, as: :contribution
end
