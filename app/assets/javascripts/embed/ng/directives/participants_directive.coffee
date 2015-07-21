settings =
  state:
    collapsed: 'collapsed'
    expanded: 'expanded'
  actionText:
    collapsed: "Show"
    expanded: "Hide"
  actionIcon:
    collapsed: 'fa-caret-down'
    expanded: 'fa-caret-up'

angular.module 'civic.directives'
  .directive 'participants', ->
    restrict: 'E'
    templateUrl: 'users/participants.html'
    scope:
      participants: '='
      heading: '='
    link: (scope, element, attrs) ->
      scope.state = settings.state.collapsed
      scope.actionText = settings.actionText.collapsed
      scope.actionIcon = settings.actionIcon.collapsed
      scope.toggle = () ->
        scope.state = if scope.state == settings.state.collapsed then settings.state.expanded else settings.state.collapsed
        scope.actionText = settings.actionText[scope.state]
        scope.actionIcon = settings.actionIcon[scope.state]
