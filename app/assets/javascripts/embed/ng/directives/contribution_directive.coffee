angular.module 'civicDirectives'
  .directive 'contribution', ['RecursionHelper', '$timeout', (RecursionHelper, $timeout) ->
    restrict: 'E'
    templateUrl: 'contributions/contribution.html'
    replace: true
    scope:
      contribution: '='
    compile: (cElement) ->
      RecursionHelper.compile cElement, (scope, element, attrs) ->
        contributionsContainer =  element.children()[2].children[2]
  ]

  .directive 'contributions', ->
    restrict: 'E'
    template: [
      '<div class="contributions" ng-transclude>',
      '</div>'
    ].join ''
    replace: true
    transclude: true
    link: (scope, element, attrs) ->
      scope.$watch ->
        parseInt element[0].clientHeight
      , (newValue, oldValue) ->
        if newValue >= 330
          element.addClass 'scroll'
        else
          element.removeClass 'scroll'

  .directive 'contribute', ['Account', 'User', 'Contribution', (Account, User, Contribution) ->
    restrict: 'E'
    templateUrl: 'contributions/form.html'
    scope:
      contribution: '='
    replace: true
    link: (scope, element, attrs) ->
      Account.registerObserverCallback 'sessionState', (data) ->
        scope.user = data

      unless scope.contribution
        scope.contribution = new Contribution

      replyToObserver = attrs.$observe 'replyTo', (val) ->
        unless _.isUndefined val
          scope.replyTo = val
          replyToObserver()

      replyToAuthorObserver = attrs.$observe 'replyToAuthor', (val) ->
        unless _.isUndefined val
          scope.replyToAuthor = val
          replyToAuthorObserver()

      scope.submitComment = ->
        result = scope.contribution.$save {}, (data) ->
          scope.contribution = new Contribution
        , (data) ->
          # TODO add errors
  ]

  .directive 'loadMoreContributions', ['Contribution', '$window', '$q', (Contribution, $window, $q) ->
    restrict: 'E'
    template: [
      '<a href class="btn btn-block">',
        'Load More ',
        '<i class="fa fa-spinner fa-spin" ng-show="loading"></i>',
      '</a>'
    ].join ''
    link: (scope, element, attrs) ->
      scope.loading = false

      element.on 'click', -> # click fallback for when infinite scrolling doesn't work
        scope.loading = true
        Contribution.loadMore (data, headers) ->
          scope.loading = false
          element.addClass "hide" if data.length < 20
  ]

