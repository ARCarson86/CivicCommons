civicControllers = angular.module 'civicControllers'

civicControllers.controller 'ConversationDetailCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', '$window', 'CivicApi', 'User', 'Conversation', 'Contribution', 'Account', 'IframeHeight', ($scope, $routeParams, $sce, $rootScope, $window, CivicApi, User, Conversation, Contribution, Account, IframeHeight) ->
  [$scope.conversation_loaded, $scope.contributions_loaded] = false

  CivicApi.setVar 'conversation_id', $routeParams.id
  $scope.conversation = Conversation.get {}, (conversation) ->
    $scope.conversation_loaded = true
    $rootScope.conversation_slug = conversation.slug

  Contribution.registerObserverCallback ->
    $scope.contributions = Contribution.getContributions()

  User.index {}, (data) ->
    Contribution.index {}, ->
      $scope.contributions_loaded = true


  $scope.login = ->
    $rootScope.flagLogin = true

]
