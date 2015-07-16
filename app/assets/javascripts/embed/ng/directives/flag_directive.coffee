angular.module 'civic.directives'
  .directive 'moderateContribution', ['$timeout', 'Contribution', ($timeout, Contribution) ->
    restrict: 'E'
    template: [
      '<div class="overlay">',
        '<div class="flag-contribution">',
          '<a href class="pull-right" ng-click="close()"><i class="fa fa-close"></i></a>',
          '<h2>Moderate Contribution</h2>',
          '<p>Please enter the reason for moderation.</p>'
          '<div errors="errors" ng-if="errors.length > 0"></div>',
          '<div messages="messages" ng-if="messages.length > 0"></div>',
          '<form ng-submit="moderateContribution()">',
            '<textarea ng-model="reason"></textarea>',
            '<button class="btn btn-submit">Report Violation</button>', '&nbsp;', '&nbsp;',
            '<a href ng-click="close()">Cancel</a>',
          '</form>',
        '</div>',
      '</div>'
    ].join ''
    replace: true
    scope:
      contribution: '='
    link: (scope, overlay, attrs) ->
      element = angular.element overlay.children()[0]
      parent = angular.element(overlay.parent())
      scope.messages = []
      scope.errors = []
      scope.moderateContribution = ->
        scope.contribution.$moderate {reason: scope.reason}, (data, headers) ->
          scope.messages.push "This contribution has been moderated."
          $timeout ->
            scope.close()
          , 5000
        , (data) ->
          scope.errors.push 'An unknown error occurred'

      scope.close = ->
        scope.$parent.$parent.moderateActive = false

      frameHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
      element[0].style.top = "#{parent[0].scrollTop + ((frameHeight/2) - 140)}px"

  ]
  .directive 'flagContribution', ['$timeout', 'Contribution', ($timeout, Contribution) ->
    restrict: 'E'
    template: [
      '<div class="overlay">',
        '<div class="flag-contribution">',
          '<a href class="pull-right" ng-click="close()"><i class="fa fa-close"></i></a>',
          '<h2>Report Violation</h2>',
          '<p>Do you think this post violates <a href="/pages/terms" target="_blank">The Civic Commons terms of service</a>? If so, please give your reason why below and submit to us.</p>'
          '<div errors="errors" ng-if="errors.length > 0"></div>',
          '<div messages="messages" ng-if="messages.length > 0"></div>',
          '<form ng-submit="flagContribution()">',
            '<textarea ng-model="reason"></textarea>',
            '<button class="btn btn-submit">Report Violation</button>', '&nbsp;', '&nbsp;',
            '<a href ng-click="close()">Cancel</a>',
          '</form>',
        '</div>',
      '</div>'
    ].join ''
    replace: true
    scope:
      contribution: '='
    link: (scope, overlay, attrs) ->
      element = angular.element overlay.children()[0]
      parent = angular.element(overlay.parent())
      scope.messages = []
      scope.errors = []
      scope.flagContribution = ->
        scope.contribution.flag {reason: scope.reason}, (data, headers) ->
          scope.messages.push "Thank you for your feedback. We will review the contribution you flagged"
          $timeout ->
            scope.close()
          , 5000
        , (data) ->
          scope.errors.push 'An unknown error occurred'

      scope.close = ->
        scope.$parent.$parent.flagActive = false

      frameHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
      element[0].style.top = "#{parent[0].scrollTop + ((frameHeight/2) - 140)}px"
  ]
