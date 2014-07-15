civicDirectives = angular.module 'civicDirectives'

civicDirectives.controller 'AccountDirective', [ '$scope', '$rootScope', 'Account', ($scope, $rootScope, Account) ->
  $scope.account = {}

  $scope.getCurrentUser = (resetCache = false) ->
    $scope.current_user = Account.getAccount {}, resetCache, (data)->
      $scope.logged_in = true
    , (data) ->
      $scope.logged_in = false

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
