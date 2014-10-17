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
  .directive 'signInLink', ['Account', (Account) ->
    restrict: 'E'
    transclude: true
    template: [
      '<a href ng-click="openAuthWindow()" ng-hide="account" ng-transclude="true" >',
      '</a>',
    ].join ''
    link: (scope, element, attrs) ->
      Account.registerObserverCallback 'sessionState', (data) ->
        scope.account = data
      , false
      scope.openAuthWindow = ->
        Account.openLogin()
  ]

  .directive 'accountShow', ['Account', (Account) ->
    restrict: 'A'
    transclude: true
    template: [
      '<span ng-show="account" ng-transclude="true" >',
      '</span>',
    ].join ''
    link: (scope, element, attrs) ->
      Account.registerObserverCallback 'sessionState', (data) ->
        scope.account = data
      , false
  ]
