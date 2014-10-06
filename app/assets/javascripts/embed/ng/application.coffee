#= require angular/angular
#= require angular-rails-templates
#= require angular-route/angular-route
#= require angular-resource/angular-resource
#= require angular-sanitize/angular-sanitize
#= require angular-cookies/angular-cookies
#= require ment.io/dist/mentio
#= require ment.io/dist/templates
#= require lodash
#= require ./helpers/civic_helpers
#= require_tree ./helpers
#= require ./services/civic_services
#= require_tree ./services
#= require ./controllers/civic_controllers
#= require_tree ./controllers
#= require ./directives/civic_directives
#= require_tree ./directives
#= require ./filters/civic_filters
#= require_tree ./filters
#= require_tree ./templates

civicApp = angular.module 'civicApp', ['ngRoute','civic.controllers', 'civic.services', 'civic.directives', 'civic.filters', 'civic.helpers', 'ngCookies', 'ngSanitize', 'templates', 'mentio']

civicApp
  .config ['$locationProvider','$routeProvider', '$windowProvider', ($locationProvider, $routeProvider, $window) ->
    $locationProvider.html5Mode(true).hashPrefix('!')
    $routeProvider
      .when '/conversations/:id', {
        controller: 'ConversationDetailCtrl',
        templateUrl: 'conversations/conversation-detail.html'
        resolve:
          conversation: ['$route', 'Conversation', ($route, Conversation) ->
            Conversation.get({id: $route.current.params.id}).$promise
          ]
        redirectTo: (params, path, search) ->
          return ''
          if $window.$get() == $window.$get().parent # not embedded
            $window.$get().location.href = "http://theciviccommons.com/conversations/#{params.id}"
      }
      .when '/404', {
        templateUrl: '404.html'
      }
      .otherwise {
        redirectTo: '/404'
      }
  ]
  .run ['$rootScope', '$location', 'IframeHeight', ($rootScope, $location, IframeHeight) ->
    $rootScope.$on '$routeChangeError', (angularEvent, current, previous, rejection) ->
      $location.path '/404' if rejection.status == 404
  ]
