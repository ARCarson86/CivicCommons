angular.module 'civic.directives'
  .directive 'contenteditable', ['$sce', ($sce) ->
    restrict: 'A' # only activate on element attribute
    require: '?ngModel' # get a hold of NgModelController
    link: (scope, element, attrs, ngModel) ->
      if(!ngModel)
        return

      # Specify how UI should be updated
      ngModel.$render = ->
        element.html($sce.getTrustedHtml(ngModel.$viewValue || ''))

      # Listen for change events to enable binding
      element.on 'blur keyup change', ->
        scope.$apply(read)

      # Write data to the model
      read = ->
        html = element.html()
        # When we clear the content editable the browser leaves a <br> behind
        # If strip-br attribute is provided then we strip this out
        if ( attrs.stripBr && html == '<br>' )
          html = ''
        ngModel.$setViewValue(html)

      unless element.html() == ''
        read(); # initialize

  ]
