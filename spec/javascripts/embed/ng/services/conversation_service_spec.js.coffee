describe 'Conversation Service', ->
  $httpBackend = Conversation = undefined

  testConversation =
    id: 1
    slug: 'test-conversation'
    title: 'Test Conversation'
    starter: 'Test Starter'
    created_at: '2012-03-19T06:50:54-04:00'
    summary: '<p>The conversation summary.</p>'
    author:
      id: 1
      name: 'John Doe'
      slug: 'john-doe'
      location: '/users/john-doe'
      avatar: 'http://s3.amazonaws.com/com.theciviccommons.int/avatars/default/avatar_70.gif'
    number_of_top_level_contributions: 10
    number_of_contributions: 30

  beforeEach ->
    jasmine.addMatchers
      toEqualData: (util, customEqualityTesters) ->
        compare: (actual, expected) ->
          result = {}
          result.pass = angular.equals actual, expected
          return result

  beforeEach ->
    module 'civicServices'

  beforeEach inject((_$httpBackend_, _Conversation_) ->
    $httpBackend = _$httpBackend_
    Conversation = _Conversation_
  )

  beforeEach ->
    $httpBackend
      .expectGET "/api/v1/conversations/#{testConversation.slug}"
      .respond testConversation

  it 'Returns the Conversation', (done) ->
    Conversation.get id: testConversation.slug, (data, headers) ->
      expect(data).toEqualData testConversation
      done()
    $httpBackend.flush()
