angular.module 'civicDirectives'
  .directive 'wysiwyg', ->
    restrict: 'E'
    scope:
      contribution: '=ngModel'
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
          '<a href class="editor-button" ng-class="{active: attachLink}" ng-click="attachLink = !attachLink">',
            '<i class="fa fa-link"></i>',
          '</a>',
          '<a href class="editor-button" ng-click="attachImg = !attachImg">',
            '<i class="fa fa-image"></i>',
          '</a>',
        '</div>',
        '<div class="editor-body" contenteditable ng-model="contribution.content"></div>',
        '<div class="editor-attachments" ng-if="(attachLink || attachImg)">',
          '<div ng-show="attachLink" class="editor-link">',
            '<div class="badge">',
              '<i class="fa fa-link"></i>',
            '</div>',
            '<input type="text" ng-model="contribution.url" />',
          '</div>',
          '<editor-images contribution="contribution" ng-show="attachImg"></editor-images>'
        '</div>',
      '</div>'
    ].join ''
    replace: true
    link: (scope, element, attrs) ->
      scope.attachImg = true if scope.contribution?.attachment
      scope.attachLink = true if scope.contribution?.url

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

  .directive 'editorImages', ['$window', '$timeout', ($window, $timeout)->
    restrict: 'E'
    scope:
      contribution: '='
    template: [
      '<div class="editor-images">',
        '<div class="badge">', '<i class="fa fa-image"></i>', '</div>',
        '<div ng-click="openDialog()" class="hint" ng-hide="contribution.attachment">Drag & Drop images here or click to select from your computer</div>',
        '<div class="attachment-info" ng-show="contribution.attachment" >',
          '<div class="preview">',
            '<img ng-src="{{contribution.attachment}}" />',
          '</div>',
          '<div class="filename">{{fileName}}</div>',
        '</div>',
      '</div>'
    ].join ''
    replace: true
    link: (scope, element, attrs) ->
      scope.previous_attachment = scope.contribution.attachment
      hiddenInput = angular.element('<input type="file" class="hide" />')
      element.append hiddenInput
      scope.openDialog = ->
        $timeout ->
          hiddenInput[0].click()

      hiddenInput.on 'change', (event) ->
        handleFile event.target.files[0]

      handleFile = (file) ->
        unless file.type.match /^image\/(png|jpg|jpeg)/
          scope.error = "Unsupported File Type"
          scope.$apply()
          return
        reader = new FileReader()
        reader.onload = (onLoadEvent) ->
          scope.contribution.attachment = onLoadEvent.target.result
          scope.fileName = file.name
          scope.$apply()
        reader.readAsDataURL(file)

      if typeof $window.FileReader == undefined
        holder.text "Not supported"
      element
        .on 'dragover', (event) ->
          event.preventDefault()
          element.addClass('hover')
        .on 'dragend', (event) ->
          event.preventDefault()
          element.removeClass('hover')
        .on 'drop', (event) ->
          element.removeClass('hover')
          event.preventDefault()
          file = event.dataTransfer.files[0]
          handleFile file

  ]
