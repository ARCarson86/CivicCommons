angular.module 'civic.directives'
  .directive 'flagContribution', ['$timeout', 'Contribution', ($timeout, Contribution) ->
    restrict: 'E'
    template: [
      '<div>',
      '<div errors="errors" ng-if="errors.length > 0"></div>',
      '<div messages="messages" ng-if="messages.length > 0"></div>',
      '<form ng-submit="flagContribution()">',
        '<textarea ng-model="reason"></textarea>',
        '<button>Submit</button>',
      '</form>',
      '</div>'
    ].join ''
    replace: true
    scope:
      contribution: '='
    link: (scope, element, attrs) ->
      scope.messages = []
      scope.errors = []
      scope.flagContribution = ->
        scope.contribution.flag {reason: scope.reason}, (data, headers) ->
          scope.messages.push "Thank you for your feedback. We will review the contribution you flagged"
          $timeout ->
            scope.close()
          , 3000
        , (data) ->
          scope.errors.push 'An unknown error occurred'

      scope.close = ->
        scope.$parent.$parent.flagActive = false

  ]
