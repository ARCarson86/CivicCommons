do ($ = jQuery, window) ->

  $.ajax
    url: 'http://civic.dev:3000/session_status.json'
    dataType: 'jsonp'
    success: (data) ->
      console.log data
