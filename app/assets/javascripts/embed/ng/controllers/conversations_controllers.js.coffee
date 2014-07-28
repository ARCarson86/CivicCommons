civicControllers = angular.module 'civicControllers'

civicControllers.controller 'ConversationDetailCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', 'CivicApi', 'Conversation', 'Contribution', 'Account', 'User', ($scope, $routeParams, $sce, $rootScope, CivicApi, Conversation, Contribution, Account, User) ->
  [$scope.conversation_loaded, $scope.contributions_loaded] = false

  CivicApi.setVar 'conversation_id', $routeParams.id
  $scope.conversation = Conversation.get {}, (conversation) ->
    $scope.conversation_loaded = true
    $rootScope.conversation_slug = conversation.slug

  $scope.contributions = Contribution.index {}, ->
    $scope.contributions_loaded = true

  Contribution.registerObserverCallback ->
    console.log 'called'
    $scope.contributions = Contribution.getContributions()
    console.log "Contribution.getContributions()"
    console.log Contribution.getContributions()

  $scope.current_user = Account.get {}

  User.index()

  $scope.login = ->
    $rootScope.flagLogin = true

  #$scope.author = User.get {conversation_id: 'what-to-do-about-dropouts', user_id: $scope.conversation.}
]
