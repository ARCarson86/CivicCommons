angular.module 'civic.controllers'
  .controller 'RemotePageCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', '$window', 'remotePage', 'CivicApi', 'Contribution', 'User', 'Account', ($scope,   $routeParams,   $sce,   $rootScope,   $window,   remotePage,   CivicApi,   Contribution, User, Account) ->
    CivicApi.setVar 'contributable_type', 'remote_pages'
    CivicApi.setVar 'contributable_id', remotePage.id

    Contribution.registerObserverCallback ->
      $scope.contributions = Contribution.getContributions()

    User.index {}, (data) ->
      Contribution.index {}, ->
        $scope.contributions_loaded = true
  ]
