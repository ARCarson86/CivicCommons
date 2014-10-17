angular.module 'civic.services'
  .factory 'User', ['$resource', 'Account', 'CivicApi', ($resource, Account, CivicApi) ->
    @completed = false

    User = $resource CivicApi.endpoint(':contributable_type/:contributable_id/users/:user_id'),
      contributable_type: ->
        CivicApi.getVar 'contributable_type'
      contributable_id: ->
        CivicApi.getVar 'contributable_id'
    , query:
      method: 'GET'
      cache: true

    User.users = {}

    User.index = (params, success, failure) =>
      User.users = User.query params, (data, headers) =>
        (success || Function())(data, headers)
        User.importAccount Account.getAccount({}, false)
      , failure

    User.get = (id) ->
      User.users[id]

    User.importAccount = (account) ->
      User.users[account.id] = new User account
    return User
]
