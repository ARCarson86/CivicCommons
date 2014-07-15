civicServices = angular.module 'civicServices'

civicServices.factory 'Me', ['$resource', '$cacheFactory',
  ($resource, $cacheFactory) ->
    accountCache = $cacheFactory 'accountCache'
    Account = $resource '/api/v1/me.json', {}

    get: (refreshCache = false) ->
      if refreshCache or !accountCache.get('accountCache')
        console.log 'resetcache'
        accountCache.put 'accountInfo', Account.get
      accountCache.get 'accountCache'
]
