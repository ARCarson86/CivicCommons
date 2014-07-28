angular.module 'civicDirectives'
  .directive 'contribution', ['CivicApi', 'Contribution', (CivicApi, Contribution) ->
    restrict: 'E'
    transclude: true
    templateUrl: 'contributions/contribution.html'
    scope:
      id: '@'
    controller: ($scope) ->
    link: (scope, element, attrs) ->
      scope.contribution = Contribution.getContribution(scope.id)
  ]

  .directive 'contribute', ['User', 'Contribution', (User, Contribution) ->
    restrict: 'E'
    require: '^contribution'
    templateUrl: 'contributions/new.html'
    link: (scope, element, attrs) ->
      attrs.$observe 'replyTo', (val) ->
        scope.replyTo = val
        scope.replyToAuthor = User.getUser(val)["name"]

      attrs.$observe 'replyToAuthor', (val) ->
        scope.replyToAuthor = val

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
        console.log "comment submitted"
        console.log scope.body
        newContribution = new Contribution
          contribution:
            body: scope.body

        newContribution.$save()
  ]
