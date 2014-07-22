civicControllers = angular.module 'civicControllers'

civicControllers.controller 'ConversationDetailCtrl', ['$scope', '$routeParams', '$sce', '$rootScope', 'Conversation', 'Contribution', 'Account', 'User', ($scope, $routeParams, $sce, $rootScope, Conversation, Contribution, Account, User) ->
  [$scope.conversation_loaded, $scope.contributions_loaded] = false
  $scope.conversation = Conversation.get {id: $routeParams.id}, (conversation) ->
    $scope.conversation_loaded = true
    $rootScope.conversation_slug = conversation.slug

  $scope.contributions = Contribution.query {conversation_id: $routeParams.id}, ->
    $scope.contributions_loaded = true

  $scope.current_user = Account.get {}

  $scope.login = ->
    $rootScope.flagLogin = true

  #$scope.author = User.get {conversation_id: 'what-to-do-about-dropouts', user_id: $scope.conversation.}
]
