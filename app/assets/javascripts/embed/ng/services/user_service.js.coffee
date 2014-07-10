civicServices = angular.module 'civicServices'

civicServices.factory 'User', ['$resource',
  ($resource) ->
    $resource '/api/v1/me.json', {},
      get:
        method: 'GET'
]
