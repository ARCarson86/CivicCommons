angular.module 'civic.controllers'
  .controller 'ConversationDetailCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', '$window', 'conversation', 'CivicApi', 'User', 'Contribution', 'Account', ($scope, $routeParams, $sce, $rootScope, $window, conversation, CivicApi, User, Contribution, Account) ->
    [$scope.conversation_loaded, $scope.contributions_loaded] = false

    $scope.conversation = conversation

    CivicApi.setVar 'conversation_id', $routeParams.id

    Contribution.registerObserverCallback ->
      $scope.contributions = Contribution.getContributions()

    User.index {}, (data) ->
      Contribution.index {}, ->
        $scope.contributions_loaded = true

    $scope.login = ->
      $rootScope.flagLogin = true

  ]
