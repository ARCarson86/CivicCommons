angular.module 'civic.controllers'
  .controller 'ConversationDetailCtrl', ['$scope', '$sce', 'conversation', 'users', 'contributions', 'Account', 'Contribution', ($scope, $sce, conversation, users, contributions, Account, Contribution) ->
    $scope.conversation = conversation
    $scope.contributions = contributions
    Contribution.registerObserverCallback (data, headers) ->
      $scope.contributions = Contribution.getContributions()
    $scope.account = ->
      Account.getAccount()
  ]
