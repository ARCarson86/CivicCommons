describe 'Services', ->
  describe 'Conversation Service', ->
    $httpBackend = Conversation = undefined

    beforeEach ->
      module 'civicServices'

    beforeEach inject((_$httpBackend_, _Conversation_) ->
      $httpBackend = _$httpBackend_
      Conversation = _Conversation_
    )

    beforeEach ->
      $httpBackend
        .expectGET "/api/v1/conversations/#{testData.conversation.slug}"
        .respond testData.conversation

    it 'Returns the Conversation', (done) ->
      Conversation.get id: testData.conversation.slug, (data, headers) ->
        expect(data).toEqualData testData.conversation
        done()
      $httpBackend.flush()
