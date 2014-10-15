angular.module 'civic.controllers'
  .controller 'ConversationDetailCtrl', ['$scope', '$sce', 'conversation', 'users', 'contributions', ($scope, $sce, conversation, users, contributions) ->
    $scope.conversation = conversation
    $scope.contributions = contributions
  ]
