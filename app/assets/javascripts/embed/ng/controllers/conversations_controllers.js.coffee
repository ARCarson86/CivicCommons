civicControllers = angular.module 'civicControllers'

civicControllers.controller 'ConversationDetailCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', '$window', 'CivicApi', 'Conversation', 'Contribution', 'Account', 'User', 'IframeHeight', ($scope, $routeParams, $sce, $rootScope, $window, CivicApi, Conversation, Contribution, Account, User, IframeHeight) ->
  [$scope.conversation_loaded, $scope.contributions_loaded] = false

  CivicApi.setVar 'conversation_id', $routeParams.id
  $scope.conversation = Conversation.get {}, (conversation) ->
    $scope.conversation_loaded = true
    $rootScope.conversation_slug = conversation.slug
    #IframeHeight.updateHeight()

  $scope.contributions = Contribution.index {}, ->
    $scope.contributions_loaded = true

  Contribution.registerObserverCallback ->
    $scope.contributions = Contribution.getContributions()
    IframeHeight.updateHeight()

  $scope.current_user = Account.get {}

  User.index()

  $scope.login = ->
    $rootScope.flagLogin = true

]
