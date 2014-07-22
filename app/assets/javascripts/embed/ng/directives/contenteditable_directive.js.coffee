civicDirectives = angular.module 'civicDirectives'

civicDirectives
  .directive 'contenteditable', ['$sce', ($sce) ->
    restrict: 'A'
    require: '?ngModel'
    link: (scope, element, attrs, ngModel) ->
      return unless ngModel

      read = ->
        html = element.html()
        if( attrs.stripBr && html == '<br>' )
          html = ''
        ngModel.$setViewValue(html)

      ngModel.$render = ->
        element.html($sce.getTrustedHtml(ngModel.$viewValue || ''))

      element.on 'blur keyup change', ->
        scope.$apply(read)

      read()
  ]
