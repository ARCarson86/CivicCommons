angular.module 'civicDirectives'
  .directive 'user', ->
    restrict: 'E'
    templateUrl: 'users/user.html'
    scope:
      user: '='
    link: (scope, element, attrs) ->
  .directive 'userAvatar', ->
    restrict: 'E'
    templateUrl: 'users/avatar.html'
    scope:
      user: '='
    link: (scope, element, attrs) ->
