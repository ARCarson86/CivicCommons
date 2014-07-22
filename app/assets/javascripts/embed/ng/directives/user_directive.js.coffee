civicDirectives = angular.module 'civicDirectives'

civicDirectives
  .directive 'user', ['User', (User)->
    restrict: 'E'
    templateUrl: 'users/user.html'
    transclude: true
    link: (scope, element, attrs) ->
      scope.user = User.get conversation_id: scope.conversation.slug, user_id: attrs.id
  ]
