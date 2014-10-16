getDocHeight = ->
  Math.max document.body.scrollHeight,
    document.documentElement.scrollHeight,
    document.body.offsetHeight,
    document.documentElement.offsetHeight,
    document.body.clientHeight,
    document.documentElement.clientHeight

angular.module 'civic.services'
  .service 'IframeHeight', ['$rootScope', '$window', ($rootScope, $window) ->

    @updateHeight = ->
      $window.parent.postMessage JSON.stringify({iframeHeight: getDocHeight()}), '*'

    $rootScope.$watch ->
      getDocHeight()
    , (newValue, oldValue) =>
      @updateHeight()

    return
  ]
