settings = element = iframe = null
receiveMessage = (message) ->
  try
    if message?.data
      data = if message.data instanceof Object then message.data else JSON.parse message.data
      iframe.height = data.iframeHeight if iframe
  catch exception
    if 'console' in window
      console.log exception

defaultSettings =
  conversationId: null
  targetElement: null
  targetElementId: null
  borderStyling: '0 none' # border styling
  host: 'http://localhost:3000'

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

window.addEventListener 'message', receiveMessage, false

generateIframe = ->
  iframe = document.createElement 'iframe'
  iframe.src="#{settings.host}/embed/conversations/#{settings.conversationId}"
  iframe.style.border = settings.borderStyling
  iframe

window.civicEmbed =
  initialize: (properties = {}) ->
    settings = extend defaultSettings, properties
    element = document.getElementById settings.targetElementId
    element.appendChild generateIframe()
