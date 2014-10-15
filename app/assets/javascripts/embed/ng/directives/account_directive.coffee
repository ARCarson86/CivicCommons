angular.module 'civic.directives'
  .directive 'account', ['$rootScope', '$cookies', 'Account', ($rootScope, $cookies, Account) ->
    restrict: 'E'
    templateUrl: 'users/account.html'
    link: (scope, element, attrs) ->
      scope.openAuthWindow = ->
        Account.openLogin()

      Account.registerObserverCallback 'sessionState', (data) ->
        scope.current_user = data || {}
        scope.logged_in = !!data

      scope.signOut = ->
        Account.logOut()
  ]
  .directive 'accountAvatar', ['Account', (Account) ->
    restrict: 'E'
    scope: {}
    templateUrl: 'users/avatar.html'
    link: (scope, element, attrs) ->
      Account.registerObserverCallback 'sessionState', (data) ->
        scope.user = data || {}
        scope.user.avatar ||= '/assets/avatar_180.gif'
  ]
