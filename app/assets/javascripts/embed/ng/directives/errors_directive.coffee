angular.module 'civic.directives'
  .directive 'errors', ->
    restrict: 'A'
    replace: true
    template: [
      '<div class="errors" ng-class="{active: errors}">',
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
