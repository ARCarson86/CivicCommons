angular.module 'civic.filters'
  .filter 'linkTarget', ['$sanitize', ($sanitize) ->
    FIND_LINK_REGEX = /(<a[^>]+>)/
    LINK_TARGET_REGEX = /(target=\"(_[A-Za-z])\")/
    ATTRS_REGEX = /\s+([A-Za-z]+)="([^"]+)"/
    count = 0

    (text, target) ->
      raw = if text then text else ""
      html = []

      addText = (text) ->
        html.push text if text

      addLink = (el) ->
        target = el.match LINK_TARGET_REGEX
        if target?[1] == target
          html.push el
        else
          html.push '<a '
          while attr_match = el.match ATTRS_REGEX
            el = el.substring attr_match.index + attr_match[0].length
            html.push "#{attr_match[1]}=\"#{attr_match[2]}\" " unless attr_match[1] == 'target'
          html.push "target=\"#{target}\""
          html.push '>'

      while match = raw.match FIND_LINK_REGEX
        i = match.index
        addText raw.substring(0, i)
        addLink match[0]
        raw = raw.substring i + match[0].length

      addText raw
      $sanitize html.join('')
  ]
