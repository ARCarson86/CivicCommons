describe 'Directives', ->
  describe 'User', ->
    $compile = $scope = $element = User = element = null

    beforeEach ->
      User =
        get: (id) ->
          testData.users[id]
      module 'civic.directives', 'users/user.html', 'users/avatar.html', ($provide) ->
        $provide.value 'User', User
        return

    beforeEach(inject((_$compile_, _$rootScope_) ->
      $scope = _$rootScope_
      $compile = _$compile_
    ))

    describe 'User Directive',  ->
      anchor = null
      beforeEach ->
        $scope.user = User.get(1)
        element = $compile("<user user='user'></user>")($scope)
        $scope.$digest()
        anchor = angular.element(angular.element(element.children()).children())

      it 'links to the user on the civic commons', ->
        expect(anchor.attr('href')).toContain(testData.users[1].slug)
        expect(anchor.text()).toEqual(testData.users[1].name)

      it 'opens in a new window', ->
        expect(anchor.attr('target')).toEqual '_blank'

    describe 'User Avatar Directive',  ->
      anchor = null
      img = null
      beforeEach ->
        $scope.user = User.get(1)
        element = $compile("<user-avatar user='user'></user-avatar>")($scope)
        $scope.$digest()
        anchor = angular.element(angular.element(element.children()).children())
        img = angular.element(anchor.children())

      it 'contains an image link to the user on the civic commons', ->
        expect(anchor.attr('href')).toContain(testData.users[1].slug)
        expect(img.attr('src')).toEqual(testData.users[1].avatar)

      it 'opens in a new window', ->
        expect(anchor.attr('target')).toEqual '_blank'
