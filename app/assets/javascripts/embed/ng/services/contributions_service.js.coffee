civicServices = angular.module 'civicServices'

civicServices.factory 'Contribution', ['$resource',
  ($resource) ->
    $resource '/api/v1/conversations/:conversation_id/contributions.json', {},
      query:
        method: 'GET'
        isArray: true
]
