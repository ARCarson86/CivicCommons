civicServices = angular.module 'civic.services'

civicServices.factory 'Account', ['$rootScope', '$cacheFactory', '$cookies', '$q', '$resource', '$timeout', '$window', 'CivicApi', ($rootScope, $cacheFactory, $cookies, $q, $resource, $timeout, $window, CivicApi) ->
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
      $timeout ->
        Account.loginWindow = $window.open 'http://localhost:3000/people/popup_new_login', 'loginWindow', 'width=650, height=300, top=50, left=50'
      , 0, false

    Account.closeLogin = ->
      Account.loginWindow?.close()

    Account.logOut = ->
      Account.delete {}, ->
        Account.notifyObservers 'sessionState', null

    Account.registerObserverCallback = (group, callback) ->
      observerCallbacks[group].push callback
      Account.getAccount {}, true, null, null if group == 'sessionState'

    Account.notifyObservers = (group, data) ->
      angular.forEach observerCallbacks[group], (callback) ->
        (callback || Function())(data)

    $rootScope.$watch ->
      $cookies.civiccommons_login_update
    , (newValue, oldValue) ->
      Account.getAccount {}, true, null, null unless newValue == oldValue


    Account
]
