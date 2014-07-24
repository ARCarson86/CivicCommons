civicDirectives = angular.module 'civicDirectives'

civicDirectives
  .directive 'user', ['User', (User)->
    restrict: 'E'
    templateUrl: 'users/user.html'
    transclude: true
    link: (scope, element, attrs) ->
      console.log attrs
      scope.user = User.get user_id: attrs.id
  ]
