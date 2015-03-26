angular.module 'civic.directives'
  .directive 'errors', ->
    restrict: 'A'
    replace: true
    template: [
      '<div class="alerts errors" ng-class="{active: errors}" ng-if="errors.length > 0">',
        '<a href class="close" ng-click="dismiss()" title="Dismiss"><i class="fa fa-close"></i></a>',
        '<h2>We\'ve encountered an error </h2>',
        '<ul>',
          '<li ng-repeat="error in errors">{{error}}</li>'
        '</ul>',
      '</div>'
    ].join ''
    scope:
      errors: '='
    link: (scope, element, attrs) ->
      scope.dismiss = ->
        scope.errors = []
  .directive 'messages', ->
    restrict: 'A'
    replace: true
    template: [
      '<div class="alerts messages" ng-class="{active: messages}" ng-if="messages.length > 0">',
        '<a href class="close" ng-click="dismiss()" title="Dismiss"><i class="fa fa-close"></i></a>',
        '<h2>Message</h2>',
        '<ul>',
          '<li ng-repeat="message in messages">{{message}}</li>'
        '</ul>',
      '</div>'
    ].join ''
    scope:
      messages: '='
    link: (scope, element, attrs) ->
      scope.dismiss = ->
        scope.messages = []

