angular.module 'civic.controllers'
  .controller 'RemotePageCtrl', ['$scope', '$sce', 'CivicApi', 'account', 'contributions', ($scope, $sce, CivicApi, account, contributions) ->
    $scope.user = account
    $scope.contributions = contributions
    $scope.totalContributions = CivicApi.getVar 'totalContributions', 0

  ]
