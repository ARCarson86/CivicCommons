json.(contribution, :id, :content, :created_at, :parent_id, :url)

if contribution.attachment_file_name
  json.attachment contribution.attachment.url :medium
  json.attachment_full contribution.attachment.url :full
end

if contribution.embedly_code
  json.embed JSON.parse(contribution.embedly_code)['oembed'].select { |k,v| ['title', 'description', 'url', 'provider_name', 'provider_url', 'thumbnail_url'].include? k }
end

json.owner_id contribution.owner

if contribution.parent_id.blank?
  json.set! :contributions do
    json.partial! 'api/v1/contributions/contribution', collection: contribution.descendants, as: :contribution
  end
end
