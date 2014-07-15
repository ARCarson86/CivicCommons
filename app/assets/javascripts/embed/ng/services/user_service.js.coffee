civicServices = angular.module 'civicServices'

civicServices.factory 'Account', ['$resource', '$cacheFactory',
  ($resource, $cacheFactory) ->
    accountCache = $cacheFactory 'accountCache'
    Account = $resource '/api/v1/sessions', {},
      get:
        url: '/api/v1/me'
        method: 'GET'
      post:
        method: 'POST'
      delete:
        method: 'DELETE'

    Account.getAccount = (params, resetCache, success, error) ->
      account = accountCache.get('accountInfo')
      if resetCache or !account
        account = Account.get(params, success, error)
        accountCache.put 'accountInfo', account

      account

    Account
]
