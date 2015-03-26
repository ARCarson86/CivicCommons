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

embedObj = ->
  @initialized = false

  @settings =
    conversationId: ''
    targetElement: null
    targetElementId: null
    targetElementEmbedId: ''
    borderStyling: '0 none'
    host: null
    embedType: 'comments'
    remotePageAddress: window.location.href
    autoInit: true
  @log = (message) ->
    logArr = ['Civic Embed: '].concat arguments
    console?.log.apply console, logArr
  @generateId = (length) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    "civiccommons-embed-#{id.substr 0, length}"
  @getParamsFromScriptSrc = ->
    return unless scriptTag = document.getElementById 'cc_embed_script_tag'
    PARAM_REGEX = /(\w+)=\"?([^&]*)\"?/
    params = {}
    scriptSearch = scriptTag.src.substring scriptTag.src.match(/\?/)?.index + 1
    while match = scriptSearch.match PARAM_REGEX
      params[match[1]] = decodeURIComponent match[2]
      scriptSearch = scriptSearch.substring match.index + match[0].length
    return params
  @getHostFromScriptSrc = ->
    return unless scriptTag = document.getElementById 'cc_embed_script_tag'
    domain = scriptTag.src.split('/')[2]
    "http://#{domain}"
  @findOrGenerateContainer = ->
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
  @generateIframe = ->
    src = []
    iframe = document.createElement 'iframe'
    src.push "#{@settings.host}/embed/"
    src.push "#{@settings.embedType}/" if @settings.embedType in availableEmbedTypes
    src.push @settings.conversationId if @settings.conversationId
    src.push "?remotePageAddress=#{@settings.remotePageAddress}" if @settings.remotePageAddress
    iframe.style.border = @settings.borderStyling
    iframe.style.width = "100%"

    # prevent back button from breaking the comment embed
    setTimeout ->
      iframe.src = src.join ''
    , 0

    iframe
  @initialize = (options = {}) ->
    return if @initialized
    @initialized = true
    extend @settings, @getParamsFromScriptSrc()
    extend @settings, options
    @settings.host = @getHostFromScriptSrc() unless @settings.host
    @settings.targetElementEmbedId = @generateId 8
    @settings.targetElement ||= @findOrGenerateContainer()
    @settings.targetElement.appendChild(@generateIframe()) if @settings.targetElement

  @initialize() if @settings.autoInit

  return this

window.civicCommonsEmbed = embedObj()
