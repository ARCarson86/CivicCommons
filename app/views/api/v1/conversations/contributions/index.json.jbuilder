json.cache! [:api, :v1, contributable, contributable.updated_at, params[:page]] do
  json.total @contributions.count
  json.partial! 'api/v1/contributions/contributions', contributions: @contributions
end
