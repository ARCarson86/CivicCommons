civicDirectives = angular.module 'civicDirectives'

civicDirectives.controller 'AccountDirective', [ '$scope', '$rootScope', '$document', '$cookies', '$http', 'Account', ($scope, $rootScope, $document, $cookies, $http, Account) ->
  $scope.account = {}

  $scope.$watch () ->
    $cookies.civiccommons_login_update
  , (newValue, oldValue) ->
    unless newValue == oldValue
      $scope.getCurrentUser(true)

  $scope.getCurrentUser = (resetCache = false) ->
    Account.getAccount {}, resetCache, (data, status, headers)->
      $scope.current_user = data
      $scope.logged_in = true
    , (error) ->
      $scope.current_user = error.data
      $scope.logged_in = true

  $scope.getCurrentUser()

  #TODO Trigger login when this flag changes
  $rootScope.$watch 'flagLogin', (newValue, oldValue) ->
    #if newValue
    #$scope.signIn()

  $scope.signIn = ->
    Account.post person:
      email: $scope.account.email
      password: $scope.account.password
    , (data) -> # success callback
      $scope.resetErrors()
      $scope.getCurrentUser true
      $scope.account = {}
    , (data) -> # failure callback
      $scope.setError status: 'warning', message: 'Invalid login'

  $scope.signOut = ->
    Account.delete {}, -> # success callback
      $scope.getCurrentUser true

  $scope.errors = []

  $scope.setError = (error, clear = true) ->
    $scope.resetErrors() if clear
    $scope.errors.push error

  $scope.resetErrors = ->
    $scope.errors = []
]
