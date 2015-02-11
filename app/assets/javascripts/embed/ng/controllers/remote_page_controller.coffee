angular.module 'civic.controllers'
  .controller 'RemotePageCtrl', ['$scope', '$sce', 'CivicApi', 'Account', 'remotePage', 'account', 'contributions', ($scope, $sce, CivicApi, Account, remotePage, account, contributions) ->
    $scope.user = account
    $scope.contributions = contributions
    $scope.totalContributions = CivicApi.getVar 'totalContributions', 0
    $scope.remotePage = remotePage
    console.log $scope.remotePage

    $scope.account = ->
      Account.getAccount()

  ]
