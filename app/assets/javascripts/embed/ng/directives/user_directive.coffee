angular.module 'civicDirectives'
  .directive 'user', ['User', (User)->
    restrict: 'E'
    templateUrl: 'users/user.html'
    scope:
      user: '='
    link: (scope, element, attrs) ->
  ]
  .directive 'userAvatar', ['User', (User)->
    restrict: 'E'
    templateUrl: 'users/avatar.html'
    scope:
      user: '='
    link: (scope, element, attrs) ->
  ]
