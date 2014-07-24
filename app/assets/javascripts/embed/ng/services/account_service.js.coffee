civicServices = angular.module 'civicServices'

civicServices.factory 'Account', ['$resource', '$cacheFactory', 'CivicApi',
  ($resource, $cacheFactory, CivicApi) ->
    accountCache = $cacheFactory 'accountCache'
    Account = $resource CivicApi.endpoint('sessions'), {},
      get:
        url: CivicApi.endpoint 'me'
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
