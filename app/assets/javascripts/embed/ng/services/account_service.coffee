civicServices = angular.module 'civic.services'

civicServices.factory 'Account', ['$rootScope', '$cacheFactory', '$cookies', '$resource', '$window', 'CivicApi', ($rootScope, $cacheFactory, $cookies, $resource, $window, CivicApi) ->
    observerCallbacks =
      sessionState: []
      loginRequired: []

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
        account = Account.get params, (data, headers)->
          Account.notifyObservers 'sessionState', data
          Account.closeLogin()
          (success || Function())()
        , (data) ->
          Account.notifyObservers 'sessionState', null
          (error || Function())()
        accountCache.put 'accountInfo', account

      account

    Account.openLogin = ->
      Account.loginWindow = $window.open '/people/login/compact', 'loginWindow', 'width=650, height=300, top=50, left=50'
      return true

    Account.closeLogin = ->
      Account.loginWindow?.close()
      return true

    Account.logOut = ->
      Account.delete {}, ->
        Account.notifyObservers 'sessionState', null

    Account.registerObserverCallback = (group, callback, resetCache = true) ->
      observerCallbacks[group].push callback
      Account.getAccount {}, resetCache, null, null if group == 'sessionState'

    Account.notifyObservers = (group, data) ->
      angular.forEach observerCallbacks[group], (callback) ->
        (callback || Function())(data)

    $rootScope.$watch ->
      $cookies.civiccommons_login_update
    , (newValue, oldValue) ->
      Account.getAccount {}, true, null, null unless newValue == oldValue


    Account
]
