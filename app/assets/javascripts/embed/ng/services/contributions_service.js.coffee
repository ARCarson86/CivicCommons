civicServices = angular.module 'civicServices'

civicServices.factory 'Contribution', ['$resource', 'CivicApi', ($resource, CivicApi) ->
    $resource CivicApi.endpoint('conversations/:conversation_id/contributions'), {},
      query:
        method: 'GET'
        isArray: true
]
