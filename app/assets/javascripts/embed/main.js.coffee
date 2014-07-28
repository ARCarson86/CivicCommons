#= require angular/angular
#= require angular-rails-templates
#= require angular/angular-route
#= require angular/angular-resource
#= require angular/angular-sanitize
#= require angular/angular-cookies
#= require angular/ui-bootstrap-tpls-0.11.0
#= require lodash
#= require ./ng/services/civic_services
#= require_tree ./ng/services
#= require ./ng/controllers/civic_controllers
#= require_tree ./ng/controllers
#= require ./ng/directives/civic_directives
#= require_tree ./ng/directives
#= require_tree ./ng/templates

civicApp = angular.module 'civicApp', ['ngRoute','civicControllers', 'civicServices', 'civicDirectives', 'ngCookies', 'ngSanitize', 'templates', 'ui.bootstrap']

civicApp.config ['$locationProvider','$routeProvider', ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode(true).hashPrefix('!')
  $routeProvider
    .when '/conversations/:id', {
      controller: 'ConversationDetailCtrl',
      templateUrl: 'conversations/conversation-detail.html'
    }
    .otherwise {
      redirect_to: '/'
    }
]
