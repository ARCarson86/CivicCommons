do ($ = jQuery, window) ->

  $.ajax
    url: "http://#{window.location.host}/session_status.json"
    dataType: 'jsonp'
    success: (data) ->
      console.log data
