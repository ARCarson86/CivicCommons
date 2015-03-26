describe 'Directives', ->
  describe 'Contribution', ->
    Contribution = Account = $timeout = $compile = $rootScope = scope = $element = element = link = null

    beforeEach ->
      User =
        getUser: (id) ->
          testData.users[id]
      Account =
        get: ->
          testData.users[0]
        registerObserverCallback: (group, callback) ->
          callback(testData.users[0])
      module 'civic.helpers', 'civic.directives', 'civic.services', 'contributions/contribution.html', 'users/avatar.html', 'users/user.html', 'contributions/form.html', ($provide)->
        $provide.value 'User', User
        $provide.value 'Account', Account
        return

    beforeEach(inject((_$compile_, _$timeout_, $rootScope, _Contribution_) ->
      $compile = _$compile_
      scope = $rootScope.$new()
      $timeout = _$timeout_
      scope.contribution = new _Contribution_ testData.contributions[0]
    ))


    describe 'Contribution Directive', ->
      element = null

      it 'contains the contribution content', ->
        element = $compile('<contribution contribution="contributions"></contribution>')(scope)
        scope.$digest()

        setTimeout ->
          expect(element.html()).toContain(testData.contributions[0].content)
        , 100
