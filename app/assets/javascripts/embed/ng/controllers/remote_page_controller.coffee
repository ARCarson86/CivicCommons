angular.module 'civic.controllers'
  .controller 'RemotePageCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', '$window', 'remotePage', 'CivicApi', 'Contribution', 'User', 'Account', ($scope,   $routeParams,   $sce,   $rootScope,   $window,   remotePage,   CivicApi,   Contribution, User, Account) ->
    CivicApi.setVar 'contributable_type', 'remote_pages'
    CivicApi.setVar 'contributable_id', remotePage.id

    Account.registerObserverCallback 'sessionState', (data) ->
      $scope.user = data

    Contribution.registerObserverCallback ->
      $scope.contributions = Contribution.getContributions()
      $scope.totalContributions = CivicApi.getVar 'totalContributions', 0

    User.index {}, (data) ->
      Contribution.index {}, ->
        $scope.contributions_loaded = true
  ]
