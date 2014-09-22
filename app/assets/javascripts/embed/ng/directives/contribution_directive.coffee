angular.module 'civicDirectives'
  .directive 'contribution', ['RecursionHelper', '$timeout', (RecursionHelper, $timeout) ->
    restrict: 'EA'
    templateUrl: 'contributions/contribution.html'
    replace: true
    scope:
      contribution: '='
    compile: (cElement) ->
      RecursionHelper.compile cElement, (scope, element, attrs) ->
        contributionsContainer =  element.children()[1].children[2]
        scope.$watch ->
          parseInt getComputedStyle(contributionsContainer).height
        , (newValue, oldValue) ->
          if newValue >= 300
            angular.element contributionsContainer
              .addClass 'scroll'
          else
            angular.element contributionsContainer
              .removeClass 'scroll'

  ]

  .directive 'contribute', ['Account', 'User', 'Contribution', (Account, User, Contribution) ->
    restrict: 'E'
    templateUrl: 'contributions/form.html'
    scope:{}
    link: (scope, element, attrs) ->
      Account.registerObserverCallback 'sessionState', (data) ->
        scope.user = data

      scope.contribution = Contribution.new()
      replyToObserver = attrs.$observe 'replyTo', (val) ->
        unless _.isUndefined val
          scope.replyTo = val
          replyToObserver()

      replyToAuthorObserver = attrs.$observe 'replyToAuthor', (val) ->
        unless _.isUndefined val
          scope.replyToAuthor = val
          replyToAuthorObserver()

      attrs.$observe 'active', (val) ->
        if val == "true" && !attrs.replyToParent
          scope.initialized = "true" # Put it in the DOM
          setTimeout -> # setting timeout to allow template to render
            inputs = element.find('form').children() # get form children
            for el in inputs
              if el.tagName == "DIV" && el.getAttribute("contenteditable") != null
                el.focus()
                return # return if we've found it
          , 1 # 1ms
        scope.active = val # Show the form

      scope.submitComment = ->
        result = contribution.$save()
  ]

  .directive 'loadMoreContributions', ['Contribution', '$window', '$q', (Contribution, $window, $q) ->
    restrict: 'E'
    template: [
      '<a href class="btn btn-block">',
        'Load More ',
        '<i class="icon-spinner icon-spin" ng-show="loading"></i>',
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

