angular.module 'civicDirectives'
  .directive 'user', ['User', (User)->
    restrict: 'E'
    templateUrl: 'users/user.html'
    link: (scope, element, attrs) ->
      userWatcher = null
      idObserver = attrs.$observe 'id', (val) ->
        userWatcher = scope.$watch ->
          User.getUser(val)
        , (userobj) ->
          if userobj
            scope.user = userobj
            userWatcher()
            idObserver()
  ]
  .directive 'userAvatar', ['User', (User)->
    restrict: 'E'
    templateUrl: 'users/avatar.html'
    link: (scope, element, attrs) ->
      userWatcher = null
      idObserver = attrs.$observe 'id', (val) -> # id starts uninitialized, we wait for it to initialize
        userWatcher = scope.$watch -> # watch the user object to see if it's ever initialized
          User.getUser(val)
        , (userobj) ->
          if userobj # if we got an actual user back, let's assign it
            scope.user = userobj
            userWatcher() && idObserver() # clear the watcher and observer
  ]
