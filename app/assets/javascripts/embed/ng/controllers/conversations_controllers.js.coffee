civicControllers = angular.module 'civicControllers'

civicControllers.controller 'ConversationDetailCtrl', ['$scope', '$routeParams', '$sce', 'Conversation', 'Contribution', 'User', ($scope, $routeParams, $sce, Conversation, Contribution, User) ->
  [$scope.conversation_loaded, $scope.contributions_loaded] = false
  $scope.conversation = Conversation.get {id: $routeParams.id}, (conversation) ->
    $scope.conversation_loaded = true

  $scope.contributions = Contribution.query {conversation_id: $routeParams.id}, ->
    $scope.contributions_loaded = true

  $scope.current_user = User.get {}
]
