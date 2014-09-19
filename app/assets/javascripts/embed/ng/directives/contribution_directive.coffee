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

  .directive 'contribute', ['User', 'Contribution', (User, Contribution) ->
    restrict: 'E'
    templateUrl: 'contributions/new.html'
    link: (scope, element, attrs) ->
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
        newContribution = new Contribution
          contribution:
            content: scope.content
            parent_id: scope.replyTo

        result = newContribution.$save()
  ]

  .directive 'loadMoreContributions', ['Contribution', '$window', '$q', (Contribution, $window, $q) ->
    restrict: 'E'
    template: '<a href class="btn btn-default btn-block">Load More</a>'
    replace: true
    link: (scope, element, attrs) ->
      offset = parseInt(attrs.offset, 10) || 10
      scrolling = false

      element.on 'click', -> # click fallback for when infinite scrolling doesn't work
        element.addClass "disabled"
        Contribution.loadMore (data, headers) ->
          element.removeAttr 'disabled'
          element.addClass "hide" if data.length < 20
          scrolling = false
  ]

