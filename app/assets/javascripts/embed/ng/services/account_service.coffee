civicServices = angular.module 'civic.services'

civicServices.factory 'Account', ['$rootScope', '$cookies', '$resource', '$window', 'CivicApi', 'User', ($rootScope, $cookies, $resource, $window, CivicApi, User) ->
  observerCallbacks =
    sessionState: [
      (data) ->
        if data
          User.importAccount data
          Account.closeLogin()
        else
          Account.account = null
    ]
    loginRequired: []

  Account = $resource CivicApi.endpoint('sessions'), {},
    get:
      url: CivicApi.endpoint 'me'
      method: 'GET'
      interceptor:
        responseError: (rejection) ->
          if rejection.status == 401
            return rejection.data
      transformResponse: (data, headers) =>
        responseData = angular.fromJson data
        Account.account = if (responseData?.id) then new Account(responseData) else null
        Account.notifyObservers 'sessionState', Account.account
        return Account.account
    post:
      method: 'POST'
    delete:
      method: 'DELETE'

  Account.account = null

  Account.getAccount = () =>
    if Account.account?.id then Account.account else false

  Account.openLogin = ->
    Account.loginWindow = $window.open '/people/login/compact', 'loginWindow', 'width=650, height=300, top=50, left=50'
    return true

  Account.closeLogin = ->
    Account.loginWindow?.close()
    return true

  Account.logOut = ->
    Account.delete {}, ->
      Account.notifyObservers 'sessionState', null

  Account.registerObserverCallback = (group, callback) ->
    observerCallbacks[group].push callback
    (callback || Function())(Account.getAccount())

  Account.notifyObservers = (group, data) ->
    angular.forEach observerCallbacks[group], (callback) ->
      (callback || Function())(data)

  $rootScope.$watch ->
    $cookies.civiccommons_login_update
  , (newValue, oldValue) ->
    Account.get({}) unless newValue == oldValue


  Account
]
