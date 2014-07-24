civicServices = angular.module 'civicServices'

civicServices.factory 'Conversation', ['$resource', 'CivicApi', ($resource, CivicApi) ->
  $resource CivicApi.endpoint('conversations/:id'), {},
    get:
      params:
        id: ->
          CivicApi.getVar 'conversation_id'
]
