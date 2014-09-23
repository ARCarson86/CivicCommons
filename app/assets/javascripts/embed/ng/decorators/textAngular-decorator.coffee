angular.module 'textAngularDecorator', ['textAngular']
  .config ['$provide', ($provide) ->
    $provide.decorator 'taOptions', ['$delegate', (taOptions) ->
      taOptions.toolbar = [
        ['bold', 'italics', 'underline', 'insertImage', 'insertLink', 'unlink']
      ]
      taOptions.classes =
        focussed: 'focussed'
        toolbar: 'ta-button-toolbar'
        toolbarGroup: 'ta-button-group'
        toolbarButton: 'ta-button'
        toolbarButtonActive: 'active'
        disabled: 'disabled'
        textEditor: 'form-control'
        htmlEditor: 'form-control'
      return taOptions
    ]
  ]
