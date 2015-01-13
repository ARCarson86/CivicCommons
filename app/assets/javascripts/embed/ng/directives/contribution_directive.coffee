angular.module 'civic.directives'
  .directive 'contribution', ['$window', 'RecursionHelper', 'Account', ($window, RecursionHelper, Account) ->
    restrict: 'E'
    templateUrl: 'contributions/contribution.html'
    replace: true
    scope:
      contribution: '='
    compile: (cElement) ->
      RecursionHelper.compile cElement, (scope, element, attrs) ->
        scope.createReply = ->
          scope.contribution.reply()
        element
          .on 'mouseenter', (event) ->
            scope.showactions = true
            scope.$apply()
          .on 'mouseleave', (event) ->
            scope.showactions = false
            scope.$apply()
        Account.registerObserverCallback 'sessionState', (data) ->
          scope.user = data
        scope.deleteContribution = ->
          if $window.confirm('Are you sure you want to delete this contribution?')
            scope.contribution.$delete {}, (data) ->
              scope.contribution = null


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
        else
          element.removeClass 'scroll' unless newValue == 330
  ]

  .directive 'contribute', ['Contribution', (Contribution) ->
    restrict: 'E'
    templateUrl: 'contributions/form.html'
    scope:
      contribution: '='
      inReplyTo: '='
      activeVariable: '=?'
    link: (scope, element, attrs) ->
      scope.errors = []

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
          scope.contribution = new Contribution parent_id: scope.inReplyTo
          scope.busy = false
          scope.errors = []
        , (response) ->
          data = angular.fromJson response.data
          scope.busy = false
          if data?.errors
            scope.errors.push error for error in data.errors
          else
            scope.errors.push 'An unknown error occurred'
      scope.cancel = ->
        unless scope.contribution.is_new_record()
          scope.$parent.$parent.editContribution = false
        else if scope.contribution.parent_id
          scope.contribution.reply()
        else
          scope.$parent.contributionActive = false

  ]

  .directive 'loadMoreContributions', ['Contribution', '$window', '$q', (Contribution, $window, $q) ->
    restrict: 'E'
    replace: true
    template: [
      '<a href class="load-more-contributions btn btn-block" ng-hide="count == total">',
        'Load More',' ',
        '<i class="fa fa-spinner fa-spin" ng-show="loading"></i>',
      '</a>'
    ].join ''
    link: (scope, element, attrs) ->
      scope.loading = false

      scope.total = Contribution.total()
      scope.count = Contribution.count()

      Contribution.registerObserverCallback ->
        scope.count = Contribution.count()

      element.on 'click', ->
        scope.loading = true
        Contribution.loadMore (data, headers) ->
          scope.loading = false
  ]
