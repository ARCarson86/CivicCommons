civicDirectives = angular.module 'civicDirectives'
  .directive 'form', ->
    restrict: 'E'
    link: (scope, element, attrs, ngModel) ->
      element.on 'keydown', (e) ->
        if e.keyCode == 13 && (e.metaKey || e.ctrlKey)
          element.triggerHandler('submit')
        else if e.keyCode == 13 && e.shiftKey
          document.execCommand 'formatBlock', false, 'br'
        else if e.keyCode == 13
          document.execCommand 'formatBlock', false, 'p'
