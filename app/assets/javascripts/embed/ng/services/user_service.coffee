angular.module 'civic.services'
  .factory 'User', ['$resource', 'CivicApi', ($resource, CivicApi) ->
    @users = {}
    @initialized = false

    User = $resource CivicApi.endpoint(':contributable_type/:contributable_id/users/:user_id'),
      contributable_type: ->
        CivicApi.getVar 'contributable_type'
      contributable_id: ->
        CivicApi.getVar 'contributable_id'
    , query:
      method: 'GET'
      cache: true

    User.index = (params, success, failure) ->
      User.users = User.query params, success, failure

    User.get = (id) ->
      User.users[id]

    return User
]
