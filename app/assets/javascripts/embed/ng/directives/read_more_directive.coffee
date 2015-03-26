settings =
  state:
    collapsed: 'collapsed'
    expanded: 'expanded'
  actionText:
    collapsed: "Show More"
    expanded: "Show Less"
  actionIcon:
    collapsed: 'fa-caret-down'
    expanded: 'fa-caret-up'

angular.module 'civic.directives'
  .directive 'readMore', () ->
    restrict: 'E'
    replace: true
    scope:
      state: '@'
    template: [
      '<div class="read-more-container" ng-class="state" state="collapsed">'
        '<div class="content" ng-transclude></div>'
        '<div class="read-more-link">'
          '<a href ng-click="toggle()">{{actionText}} <i class="fa" ng-class="actionIcon"></i></a>'
        '</div>'
      '</div>'
    ].join ''
    transclude: true
    link: (scope, element, attrs) ->
      scope.actionText = settings.actionText.collapsed
      scope.actionIcon = settings.actionIcon.collapsed
      scope.toggle = () ->
        scope.state = if scope.state == settings.state.collapsed then settings.state.expanded else settings.state.collapsed
        scope.actionText = settings.actionText[scope.state]
        scope.actionIcon = settings.actionIcon[scope.state]
