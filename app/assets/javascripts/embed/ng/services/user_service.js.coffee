civicServices = angular.module 'civicServices'

civicServices.factory 'User', ['$resource', '$cacheFactory', 'CivicApi', ($resource, $cacheFactory ,CivicApi) ->
  $resource CivicApi.endpoint('conversations/:conversation_id/users/:user_id'),
    conversation_id: ->
      CivicApi.getVar 'conversation_id'

]
