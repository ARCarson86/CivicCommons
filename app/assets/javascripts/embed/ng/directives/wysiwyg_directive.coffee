angular.module 'civicDirectives'
  .directive 'wysiwyg', ->
    restrict: 'E'
    scope:
      text: '=ngModel'
    transclude: true
    template: [
      '<div class="editor">',
        '<div class="editor-toolbar">',
          '<editor-action action="bold">',
            '<i class="fa fa-bold"></i>',
          '</editor-action>',
          '<editor-action action="italic">',
            '<i class="fa fa-italic"></i>',
          '</editor-action>',
          '<editor-action action="underline">',
            '<i class="fa fa-underline"></i>',
          '</editor-action>',
          '<a href class="editor-button" ng-click="attachLink = !attachLink">',
            '<i class="fa fa-link"></i>',
          '</a>',
          '<a href class="editor-button" ng-click="attachImg = !attachImg">',
            '<i class="fa fa-image"></i>',
          '</a>',
        '</div>',
        '<div class="editor-body" contenteditable ng-model="text"></div>',
        '<div class="editor-attachments" ng-if="(attachLink || attachImg)">',
          'hi',
          '{{attachedImg}}',
          '<editor-images image="attachedImg" ng-show="attachImg"></editor-images>'
        '</div>',
      '</div>'
    ].join ''
    replace: true
    link: (scope, element, attrs) ->

  .directive 'editorAction', ['$document', ($document) ->
    restrict: 'E'
    replace: true
    transclude: true
    template: [
      '<a href class="editor-button" ng-transclude>',
      '</a>'
    ].join ''
    link: (scope, element, attrs) ->
      return unless attrs['action']
      element.on 'click', (event) ->
        event.preventDefault()
        document.execCommand attrs['action'], false, null
  ]

  .directive 'editorImages', ['$window', ($window)->
    restrict: 'E'
    scope:
      image: '='
    template: [
      '<div class="editor-images">',
        '<div class="holder">',
        '</div>',
      '</div>'
    ].join ''
    replace: true
    link: (scope, element, attrs) ->
      holder = angular.element(element.children()[0])
      if typeof $window.FileReader == undefined
        holder.text "Not supported"
      holder
        .on 'dragover', (event) ->
          event.preventDefault()
          holder.addClass('hover')
        .on 'dragend', (event) ->
          event.preventDefault()
          holder.removeClass('hover')
        .on 'drop', (event) ->
          event.preventDefault()
          file = event.dataTransfer.files[0]
          reader = new FileReader()
          reader.onload = (onLoadEvent) ->
            holder.css 'background', "url(#{onLoadEvent.target.result}) no-repeat center"
          console.log 'file', file
          reader.readAsDataURL(file)
          console.log 'event', event
  ]
