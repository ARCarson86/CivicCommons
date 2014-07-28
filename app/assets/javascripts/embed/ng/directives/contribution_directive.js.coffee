angular.module 'civicDirectives'
  .directive 'contribution', ['CivicApi', 'Contribution', (CivicApi, Contribution) ->
    restrict: 'E'
    templateUrl: 'contributions/contribution.html'
    scope:
      id: '@'
    controller: ($scope) ->
    link: (scope, element, attrs) ->
      #scope.contribution = Contribution.getContribution(scope.id)
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
