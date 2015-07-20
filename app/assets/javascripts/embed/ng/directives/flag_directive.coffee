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
  .directive 'markContribution', ['$timeout', 'Contribution', ($timeout, Contribution) ->
    restrict: 'E'
    template: [
      '<div class="overlay">',
        '<div class="add-rating">',
          '<a href class="pull-right" ng-click="close()"><i class="fa fa-close"></i></a>',
          '<h2>Mark Reply As:</h2>',
          '<ul>',
          '<li><a href ng-click="toggle(\'Persuasive\')">Persuasive <span id="persuasive-count-{{contribution.id}}" class="count">{{contribution.ratings["Persuasive"]["total"]}}<span></a></li>',
          '<li><a href ng-click="toggle(\'Informative\')">Informative <span id="informative-count-{{contribution.id}}" class="count">{{contribution.ratings["Informative"]["total"]}}<span></a></li>',
          '<li><a href ng-click="toggle(\'Inspiring\')">Inspiring <span id="inspiring-count-{{contribution.id}}" class="count">{{contribution.ratings["Inspiring"]["total"]}}<span></a></li>',
        '</div>',
      '</div>'
    ].join ''
    replace: true
    scope:
      contribution: '='
      user: '='
    link: (scope, overlay, attrs) ->
      element = angular.element overlay.children()[0]
      parent = angular.element(overlay.parent())
      scope.messages = []
      scope.errors = []
      scope.toggle = (title) ->
        if scope.user
          scope.contribution.toggle {title: title}, (data, headers) ->
            link = document.getElementById("#{title.toLowerCase()}-count-#{scope.contribution.id}")
            if data["ratings"][scope.contribution.id]
              link.innerHTML = data["ratings"][scope.contribution.id][title]["total"]
            else
              link.innerHTML = 0
          , (data) ->
            scope.errors.push 'An unknown error occurred'

      # scope.markInspiring = ->
      #   scope.toggle("Inspiring")
      # scope.markInformative = ->
      #   scope.toggle("Informative")
      # scope.markPersuasive = ->
      #   scope.toggle("Persuasive")

      scope.close = ->
        scope.$parent.$parent.markContribution = false

      frameHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
      element[0].style.top = "#{parent[0].scrollTop + ((frameHeight/2) - 140)}px"
  ]
