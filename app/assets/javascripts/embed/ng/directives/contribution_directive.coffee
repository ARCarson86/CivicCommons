angular.module 'civic.directives'
  .directive 'contribution', ['RecursionHelper', 'Account', (RecursionHelper, Account) ->
    restrict: 'E'
    templateUrl: 'contributions/contribution.html'
    replace: true
    scope:
      contribution: '='
    compile: (cElement) ->
      RecursionHelper.compile cElement, (scope, element, attrs) ->
        Account.registerObserverCallback 'sessionState', (data) ->
          scope.user = data
        scope.createReply = ->
          scope.contribution.reply()
        element
          .on 'mouseenter', (event) ->
            scope.showactions = true
            scope.$apply()
          .on 'mouseleave', (event) ->
            scope.showactions = false
            scope.$apply()


  ]

  .directive 'contributions', ['Contribution', (Contribution) ->
    restrict: 'E'
    template: [
      '<div class="contributions-list" ng-transclude>',
      '</div>'
    ].join ''
    replace: true
    transclude: true
    link: (scope, element, attrs) ->
      scope.$watch ->
        parseInt element[0].scrollHeight
      , (newValue, oldValue) ->
        if newValue > 330
          element.addClass 'scroll'
          element[0].scrollTop = newValue - 330
        else
          element.removeClass 'scroll' unless newValue == 330
  ]

  .directive 'contribute', ['Account', 'User', 'Contribution', (Account, User, Contribution) ->
    restrict: 'E'
    templateUrl: 'contributions/form.html'
    scope:
      contribution: '='
      inReplyTo: '='
    link: (scope, element, attrs) ->
      scope.errors = []
      Account.registerObserverCallback 'sessionState', (data) ->
        scope.user = data
        User.users[scope.user.id] = scope.user

      unless scope.contribution
        scope.contribution = new Contribution parent_id: scope.inReplyTo

      scope.contribute = () ->
        contributeActive = true

      replyToAuthorObserver = attrs.$observe 'replyToAuthor', (val) ->
        unless _.isUndefined val
          scope.replyToAuthor = val
          replyToAuthorObserver()

      scope.submitComment = ->
        scope.busy = true
        result = scope.contribution.save {}, (data) ->
          scope.contribution = new Contribution
          scope.busy = false
          scope.errors = []
        , (data) ->
          console.log 'arguments', arguments
          scope.busy = false
          scope.errors.push switch
            when data.status is 403 then 'You are not authorized'
            when data.status is 422 then 'Invalid Input'
            else 'An unknown error occurred'

      scope.people = [
        { name: "Kyle" }
        { name: "Testing" }
      ]

      scope.searchPeople = (term) ->
        console.log 'search', term
        ['test', 'test']

      scope.getPeopleText = (item) ->
        console.log 'getPeopleText', item
        people
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
