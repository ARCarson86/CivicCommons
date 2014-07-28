angular.module 'civicServices'
  .factory 'User', ['$resource', 'CivicApi', ($resource, CivicApi) ->
    @users = {}
    @initialized = false

    userResource = $resource CivicApi.endpoint('conversations/:conversation_id/users/:user_id'),
      conversation_id: ->
        CivicApi.getVar 'conversation_id'
    ,
      query:
        method: 'GET'
        cache: true

    indexUsers = (params = {}, success = null, failure = null) =>
      userResource.query params, (data, headers) =>
        @users = _.merge @users, data
        (success)(data,headers) if success
      , failure

    index: (params = {}, success = null, failure = null) =>
      if _.isEmpty @users
        indexUsers(params, success, failure)

    getUser: (id, success=null, failure=null) =>
      if !@initialized
        @initialized = true
        indexUsers {}, =>
          @initialized = true
        return false
      else
        return false if _.isEmpty @users
        user = @users[id]

  ]
