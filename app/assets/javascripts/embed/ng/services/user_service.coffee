angular.module 'civic.services'
  .factory 'User', ['$resource', 'CivicApi', ($resource, CivicApi) ->
    @completed = false

    User = $resource CivicApi.endpoint(':contributable_type/:contributable_id/users/:user_id'),
      contributable_type: ->
        CivicApi.getVar 'contributable_type'
      contributable_id: ->
        CivicApi.getVar 'contributable_id'
    , query:
        method: 'GET'
        cache: true
        isArray: false

    User.users = {}

    User.index = (params, success, failure) =>
      User.query params, (data, headers) =>
        angular.forEach data, (value, key) ->
          User.users[value.id] = new User value if value
        (success || Function())(data, headers)
        User.importAccount @account
      , failure

    User.get = (id) ->
      User.users[id]

    User.importAccount = (account) ->
      User.users[account.id] = new User account if account

    return User
]
