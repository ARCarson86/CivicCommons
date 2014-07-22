civicDirectives = angular.module 'civicDirectives'
  .directive 'form', ->
    restrict: 'E'
    link: (scope, element, attrs, ngModel) ->
      element.on 'keydown', (e) ->
        if e.keyCode == 13 && (e.metaKey || e.ctrlKey)
          element.triggerHandler('submit')
