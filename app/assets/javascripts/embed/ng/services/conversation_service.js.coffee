civicServices = angular.module 'civicServices'

civicServices.factory 'Conversation', ['$resource',
  ($resource) ->
    $resource '/api/v1/conversations/:id.json', {},
      get:
        cache: true
]
