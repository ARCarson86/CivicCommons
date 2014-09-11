describe 'User Service', ->
  $httpBackend = User = undefined
  beforeEach ->
    jasmine.addMatchers
      toEqualData: (util, customEqualityTesters) ->
        compare: (actual, expected) ->
          result = {}
          result.pass = angular.equals actual, expected
          return result

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

  contributors =
    2:
      id: 2
      name: 'Jane Doe'
      slug: 'jane-doe'
      location: '/users/jane-doe'
      avatar: 'http://s3.amazonaws.com/com.theciviccommons.int/avatars/default/avatar_70.gif'
    3:
      id: 3
      name: 'Jim Doe'
      slug: 'jim-doe'
      location: '/users/jim-doe'
      avatar: 'http://s3.amazonaws.com/com.theciviccommons.int/avatars/default/avatar_70.gif'

  beforeEach ->
    module 'civicServices'

  beforeEach inject((_$httpBackend_, _User_, _CivicApi_) ->
    $httpBackend = _$httpBackend_
    CivicApi = _CivicApi_
    CivicApi.setVar 'conversation_id', testConversation.slug
    User = _User_
  )

  beforeEach (done) ->
    $httpBackend
      .expectGET "/api/v1/conversations/#{testConversation.slug}/users"
      .respond contributors
    User.index {}, (data)->
      done()
    $httpBackend.flush()

  it 'Returns All Users', ->
    expect(User.index()).toEqualData contributors

  describe "that was already indexed", ->

    it 'Returns a single user', (done) ->
      expect(User.getUser(2)).toEqualData contributors[2]
      done()
