settings = element = iframe = null
receiveMessage = (message) ->
  try
    if message?.data
      data = if message.data instanceof Object then message.data else JSON.parse message.data
      iframe.height = data.iframeHeight if iframe
  catch exception
    if 'console' in window
      console.log exception

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

window.addEventListener 'message', receiveMessage, false

availableEmbedTypes = ['comments', 'conversations']

window.civicCommonsEmbed =
  settings:
    conversationId: ''
    targetElement: null
    targetElementId: ''
    targetElementEmbedId: ''
    borderStyling: '0 none'
    host: 'http://theciviccommons.com'
    embedType: 'comments'
  log: (message) ->
    logArr = ['Civic Embed: '].concat arguments
    console?.log.apply console, logArr
  generateId: (length) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    "civiccommons-embed-#{id.substr 0, length}"
  findOrGenerateContainer: ->
    unless @settings.targetElementId
      container = document.createElement 'div'
      container.id = @settings.targetElementId
      thisScript = document.scripts[document.scripts.length - 1]
      thisScript.parentNode.insertBefore(container, thisScript.nextSibling)
    else
      container = document.getElementById @settings.targetElementId
      unless container
        @log 'Target Container Not Found', @settings.targetElementId
        return null
    if container.classList
      container.classList.add(@settings.targetElementId)
    else
      container.className += " #{@settings.targetElementId}"
    return container
  generateIframe: ->
    iframe = document.createElement 'iframe'
    src = "#{@settings.host}/embed/"
    src += "#{@settings.embedType}/" if @settings.embedType in availableEmbedTypes
    src += @settings.conversationId if @settings.conversationId
    iframe.src = src
    iframe.style.border = @settings.borderStyling
    iframe
  initialize: (options = {}) ->
    extend @settings, options
    @settings.targetElementEmbedId = @generateId 8
    @settings.targetElement ||= @findOrGenerateContainer()
    @settings.targetElement.appendChild(@generateIframe()) if @settings.targetElement
