angular.module 'civicDirectives'
  .directive 'contribution', ['RecursionHelper', (RecursionHelper) ->
    restrict: 'EA'
    templateUrl: 'contributions/contribution.html'
    replace: true
    scope:
      contribution: '='
    compile: (cElement) ->
      RecursionHelper.compile cElement, (scope, element, attrs) ->
        scope.contribute = ->
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

      infiniteScroll = ->
        angular.element($window).bind 'scroll', ->
          if not scrolling and element[0].offsetTop + parseInt(element[0].offsetHeight, 10) < $window.scrollY + $window.innerHeight - offset
            scrolling = true
            deferred = $q.defer()
            element.attr 'disabled', 'disabled'
            Contribution.loadMore (data, headers) ->
              element.removeAttr 'disabled'
              element.addClass "hide" if data.length < 20
              scrolling = false

      observer = attrs.$observe 'initialized', (newValue, oldValue) ->
        return unless newValue == 'true'
        #infiniteScroll()
        observer() # destroy observer



      element.on 'click', -> # click fallback for when infinite scrolling doesn't work
        element.addClass "disabled"
        Contribution.loadMore (data, headers) ->
          element.removeAttr 'disabled'
          element.addClass "hide" if data.length < 20
          scrolling = false
  ]

