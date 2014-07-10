#= require angular/angular
#= require angular/angular-route
#= require angular/angular-resource
#= require angular/angular-sanitize
#= require lodash
#= require ./ng/services/civic_services
#= require_tree ./ng/services
#= require ./ng/controllers/civic_controllers
#= require_tree ./ng/controllers

civicApp = angular.module 'civicApp', ['ngRoute','civicControllers', 'civicServices', 'ngSanitize']

civicApp.config ['$locationProvider','$routeProvider', ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode(true).hashPrefix('!');
  $routeProvider
    .when '/conversations/:id', {
      controller: 'ConversationDetailCtrl',
      templateUrl: '/partials/conversation-detail.html'
    }
    .otherwise {
      redirect_to: '/'
    }
]


