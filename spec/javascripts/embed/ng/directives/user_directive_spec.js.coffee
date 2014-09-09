describe 'User Directive', ->
  $compile = $scope = $element = element = null
  exampleUser =
    id: 1
    name: 'John Doe'
    slug: 'john-doe'
    avatar: 'http://s3.amazonaws.com/com.theciviccommons.int/avatars/default/avatar_70.gif'

  beforeEach ->
    module 'civicDirectives', 'users/user.html', 'users/avatar.html'

  beforeEach ->
    User =
      getUser: (id) ->
        exampleUser

    module(($provide) ->
      $provide.value 'User', User
      return
    )

  beforeEach(inject((_$compile_, _$rootScope_) ->
    $scope = _$rootScope_
    $compile = _$compile_
  ))

  describe 'user object',  ->
    beforeEach ->
      element = $compile('<user id="1"></user>')($scope)
      $scope.$digest()

    it 'will link to the user on the civic commons', ->
      parts = element.html().match /<a href="http:\/\/(www\.)?theciviccommons\.com\/user\/([^"]*)".+>(.+)<\/a>/
      expect(parts[2]).toEqual(exampleUser.slug)
      expect(parts[3]).toEqual(exampleUser.name)

  describe 'user avatar block',  ->
    beforeEach ->
      element = $compile('<user-avatar id="1"></user-avatar>')($scope)
      $scope.$digest()

    it 'will contain an image link to the user on the civic commons', ->
      parts = element.html().match /<a href="http:\/\/(www\.)?theciviccommons\.com\/user\/([^"]*)".+>[^.$]+<img src="([^"]+)".+>[^.$]+<\/a>/
      expect(parts[2]).toEqual(exampleUser.slug)
      expect(parts[3]).toEqual(exampleUser.avatar)
