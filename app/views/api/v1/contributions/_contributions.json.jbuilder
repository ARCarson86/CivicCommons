json.contributions do
  json.partial! 'api/v1/contributions/contribution', collection: @contributions, as: :contribution
end
