angular.module 'civicServices'
  .factory 'User', ['$q', '$resource', '$rootScope', '$timeout', 'CivicApi', ($q, $resource, $rootScope, $timeout, CivicApi) ->
    @users = {}
    @initialized = false

    User = $resource CivicApi.endpoint('conversations/:conversation_id/users/:user_id'),
      conversation_id: ->
        CivicApi.getVar 'conversation_id'
    , query:
      method: 'GET'
      cache: true

    User.index = (params, success, failure) ->
      User.users = User.query params, success, failure

    User.get = (id) ->
      deferred = $q.defer()
      promise = deferred.promise
      promise.then (response) ->
        return response
      User.index {}, ->
        deferred.resolve User.users[id]
        return
      return promise

    return User
]
