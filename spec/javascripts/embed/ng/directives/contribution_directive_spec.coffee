describe 'Directives', ->
  describe 'Contribution', ->
    $compile = $scope = $element = element = null

    beforeEach ->
      User =
        getUser: (id) ->
          testData.users[id]
      Contribution = {}
      module 'civicDirectives', 'civicHelpers', 'contributions/contribution.html', 'users/avatar.html', 'users/user.html', 'contributions/new.html', ($provide)->
        $provide.value 'User', User
        $provide.value 'Contribution', Contribution
        return

    beforeEach(inject((_$compile_, _$rootScope_) ->
      $compile = _$compile_
      $scope = _$rootScope_.$new()
      $scope.contribution = testData.contributions[0]
    ))

    describe 'Contribution Directive', ->
      element = null
      beforeEach ->
        element = $compile('<div contribution="contribution"></div>')($scope)
        $scope.$apply()

      it 'contains the contribution content', ->
        expect(element.html()).toContain(testData.contributions[0].content)
