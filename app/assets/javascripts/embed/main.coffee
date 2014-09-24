#= require angular/angular
#= require angular-rails-templates
#= require angular-route/angular-route
#= require angular-resource/angular-resource
#= require angular-sanitize/angular-sanitize
#= require angular-cookies/angular-cookies
#= require ment.io/dist/mentio
#= require ment.io/dist/templates
#= require textAngular/src/textAngular-sanitize
#= require textAngular/src/textAngularSetup
#= require textAngular/src/textAngular
#= require lodash
#= require ./ng/helpers/civic_helpers
#= require_tree ./ng/helpers
#= require ./ng/services/civic_services
#= require_tree ./ng/services
#= require ./ng/controllers/civic_controllers
#= require_tree ./ng/controllers
#= require ./ng/directives/civic_directives
#= require_tree ./ng/directives
#= require_tree ./ng/decorators
#= require_tree ./ng/templates


civicApp = angular.module 'civicApp', ['ngRoute','civicControllers', 'civicServices', 'civicDirectives', 'civicHelpers', 'ngCookies', 'ngSanitize', 'templates', 'textAngular', 'textAngularDecorator', 'mentio']

civicApp
  .config ['$locationProvider','$routeProvider', '$windowProvider', ($locationProvider, $routeProvider, $window) ->
    $locationProvider.html5Mode(true).hashPrefix('!')
    $routeProvider
      .when '/conversations/:id', {
        controller: 'ConversationDetailCtrl',
        templateUrl: 'conversations/conversation-detail.html'
        redirectTo: (params, path, search) ->
          return ''
          if $window.$get() == $window.$get().parent # not embedded
            $window.$get().location.href = "http://theciviccommons.com/conversations/#{params.id}"
      }
      .otherwise {
        redirect_to: '/'
      }
  ]
