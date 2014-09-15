getDocHeight = ->
  Math.max document.body.scrollHeight,
    document.documentElement.scrollHeight,
    document.body.offsetHeight,
    document.documentElement.offsetHeight,
    document.body.clientHeight,
    document.documentElement.clientHeight

angular.module 'civicServices'
  .service 'IframeHeight', ['$window', '$timeout', ($window, $timeout) ->
    @updateHeight = ->
      $timeout -> # $timout will run after digest completes, ensuring the correct height is returned
        $window.parent.postMessage JSON.stringify({iframeHeight: getDocHeight()}), '*'
      , 0, false
    return
  ]
