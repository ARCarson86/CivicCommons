json.cache! [:api, :v1, @contributable, @contributable.updated_at, :users] do
  @users.each do |user|
    json.set! user.id do
      json.partial! 'api/v1/people/person', person: user
    end
  end
end
