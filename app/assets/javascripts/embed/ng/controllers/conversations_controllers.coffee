angular.module 'civic.controllers'
  .controller 'ConversationDetailCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', '$window', 'conversation', 'CivicApi', 'User', 'Contribution', 'Account', ($scope, $routeParams, $sce, $rootScope, $window, conversation, CivicApi, User, Contribution, Account) ->
    [$scope.conversation_loaded, $scope.contributions_loaded] = false

    $scope.conversation = conversation

    CivicApi.setVar 'contributable_type', 'conversations'
    CivicApi.setVar 'contributable_id', $routeParams.id

    Contribution.registerObserverCallback ->
      $scope.contributions = Contribution.getContributions()
      $scope.totalContributions = CivicApi.getVar 'totalContributions'

    User.index {}, (data) ->
      Contribution.index {}, ->
        $scope.contributions_loaded = true

    $scope.login = ->
      $rootScope.flagLogin = true

  ]
