#= require angular/angular
#= require angular-rails-templates
#= require angular-route/angular-route
#= require angular-resource/angular-resource
#= require angular-sanitize/angular-sanitize
#= require angular-cookies/angular-cookies
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

civicApp = angular.module 'civicApp', [ 'ngRoute', 'ngSanitize', 'templates', 'civic.controllers', 'civic.services', 'civic.directives', 'civic.filters', 'civic.helpers' ]

civicApp
  .config ['$locationProvider','$routeProvider', '$windowProvider', ($locationProvider, $routeProvider, $window) ->
    $locationProvider.html5Mode(true).hashPrefix('!')
    $routeProvider
      .when '/conversations/:id', {
        controller: 'ConversationDetailCtrl',
        templateUrl: 'conversations/conversation-detail.html'
        resolve:
          conversation: ['$route', 'CivicApi', 'Conversation', ($route, CivicApi, Conversation) ->
            CivicApi.setVar 'contributable_type', 'conversations'
            CivicApi.setVar 'contributable_id', $route.current.params.id
            Conversation.get({id: $route.current.params.id}).$promise
          ]
          users: ['User', (User) ->
            User.index({}).$promise
          ]
          account: ['Account', (Account) ->
            Account.get({}).$promise
          ]
          contributions: ['Contribution', (Contribution) ->
            Contribution.index({}).$promise
          ]
        redirectTo: (params, path, search) ->
          return ''
          if $window.$get() == $window.$get().parent # not embedded
            $window.$get().location.href = "http://theciviccommons.com/conversations/#{params.id}"
      }
      .when '/comments', {
        controller: 'RemotePageCtrl'
        templateUrl: 'remote_pages/show.html'
        resolve:
          remotePage: ['$q', '$route', 'RemotePage', 'CivicApi', ($q, $route, RemotePage, CivicApi) ->
            deferred = $q.defer()

            RemotePage.registerObserverCallback (page) ->
              CivicApi.setVar 'contributable_type', 'remote_pages'
              CivicApi.setVar 'contributable_id', page.id

            RemotePage.get {
              remote_page_url: $route.current.params.remotePageAddress,
              root_domain: $route.current.params.rootDomain,
              source_key: $route.current.params.sourceKey
            }, (data) ->
              unless data.conversation
                deferred.resolve data
              else
                deferred.reject status: 301, conversation: data.conversation

            deferred.promise
          ]
          users: ['$q', 'RemotePage', 'User', ($q, RemotePage, User) ->
            deferred = $q.defer()
            RemotePage.registerObserverCallback (page) ->
              User.index {}, (data) ->
                deferred.resolve(data)
            deferred.promise
          ]
          account: ['$q', 'RemotePage', 'Account', ($q, RemotePage, Account) ->
            deferred = $q.defer()
            RemotePage.registerObserverCallback (page) ->
              Account.get {}, (data) ->
                deferred.resolve(data)
              , (rejection) ->
                if rejection.status == 401
                  deferred.resolve(null)
                else
                  deferred.reject(rejection)
          ]
          contributions: ['$q', 'RemotePage', 'Contribution', ($q, RemotePage, Contribution) ->
            deferred = $q.defer()
            RemotePage.registerObserverCallback (page) ->
              Contribution.index {}, (data) ->
                deferred.resolve data
            deferred.promise
          ]
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
      $location.path "/conversations/#{rejection.conversation.slug}" if rejection.status = 301 and rejection.conversation
  ]
