angular.module 'civic.controllers'
  .controller 'RemotePageCtrl', ['$scope', '$sce', 'CivicApi', 'Account', 'Contribution', 'remotePage', 'account', 'contributions', ($scope, $sce, CivicApi, Account, Contribution, remotePage, account, contributions) ->
    $scope.user = account
    $scope.contributions = contributions
    $scope.totalContributions = CivicApi.getVar 'totalContributions', 0
    $scope.remotePage = remotePage

    Contribution.registerObserverCallback (data, headers) ->
      $scope.contributions = Contribution.getContributions()

    $scope.account = ->
      Account.getAccount()

  ]
