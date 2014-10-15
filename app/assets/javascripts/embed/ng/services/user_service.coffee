angular.module 'civic.services'
  .factory 'User', ['$resource', 'CivicApi', ($resource, CivicApi) ->
    @completed = false
    @observerCallbacks = []
    @observerCallbackSingle = []

    User = $resource CivicApi.endpoint(':contributable_type/:contributable_id/users/:user_id'),
      contributable_type: ->
        CivicApi.getVar 'contributable_type'
      contributable_id: ->
        CivicApi.getVar 'contributable_id'
    , query:
      method: 'GET'
      cache: true

    User.index = (params, success, failure) =>
      User.users = User.query params, (data, headers) =>
        @completed = true
        (success || Function())(data, headers)
        User.notifyObservers('from')
      , failure

    User.registerObserverCallback = (callback, one_time_use) =>
      unless one_time_use
        @observerCallbacks.push callback
      else
        @observerCallbackSingle.push callback
        if @completed
          User.notifyObservers()

    User.notifyObservers = =>
      angular.forEach @observerCallbacks, (callback) ->
        (callback || Function())()
      angular.forEach @observerCallbackSingle, (callback, index) =>
        (@observerCallbackSingle[index] || Function())()
        delete @observerCallbackSingle[index]

    User.get = (id) ->
      User.users[id]

    return User
]
