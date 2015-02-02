describe 'Services', ->
  describe 'User', ->
    $httpBackend = User = undefined

    beforeEach ->
      module 'civic.services'

    beforeEach inject((_$httpBackend_, _User_, _CivicApi_) ->
      $httpBackend = _$httpBackend_
      CivicApi = _CivicApi_
      CivicApi.setVar 'contributable_type', 'conversations'
      CivicApi.setVar 'contributable_id', testData.conversation.slug
      User = _User_
    )

    beforeEach ->
      $httpBackend
        .expectGET "/api/v1/me"
        .respond testData.users[1]
      $httpBackend
        .expectGET "/api/v1/conversations/#{testData.conversation.slug}/users"
        .respond testData.users

    it 'Returns All Users', (done)->
      User.query {}, (data)->
        expect(data).toEqualData testData.users
        done()
      $httpBackend.flush()

    describe 'already having been indexed', ->
      beforeEach (done) ->
        User.index {}, ->
          done()
        $httpBackend.flush()

      it 'Returns a single user', () ->
        expect(User.get(2)).toEqualData testData.users[2]
