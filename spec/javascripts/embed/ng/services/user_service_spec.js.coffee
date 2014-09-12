describe 'Services', ->
  describe 'User', ->
    $httpBackend = User = undefined

    beforeEach ->
      module 'civicServices'

    beforeEach inject((_$httpBackend_, _User_, _CivicApi_) ->
      $httpBackend = _$httpBackend_
      CivicApi = _CivicApi_
      CivicApi.setVar 'conversation_id', testData.conversation.slug
      User = _User_
    )

    beforeEach (done) ->
      $httpBackend
        .expectGET "/api/v1/conversations/#{testData.conversation.slug}/users"
        .respond testData.users
      User.index {}, (data)->
        done()
      $httpBackend.flush()

    it 'Returns All Users', ->
      expect(User.index()).toEqualData testData.users

    describe "that was already indexed", ->

      it 'Returns a single user', (done) ->
        expect(User.getUser(2)).toEqualData testData.users[2]
        done()
