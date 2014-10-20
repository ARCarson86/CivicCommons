json.cache! [:api, :v1, contributable, contributable.updated_at, params[:page]] do
  json.partial! 'api/v1/contributions/contributions', contributions: @contributions
end
