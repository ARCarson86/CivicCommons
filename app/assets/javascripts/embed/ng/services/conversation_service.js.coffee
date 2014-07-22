civicServices = angular.module 'civicServices'

civicServices.factory 'Conversation', ['$resource', 'CivicApi',
  ($resource, CivicApi) ->
    $resource CivicApi.endpoint('conversations/:id'), {},
      get:
        cache: true
]
