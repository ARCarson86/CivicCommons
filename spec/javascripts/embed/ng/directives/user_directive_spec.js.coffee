describe 'User Directives', ->
  $compile = $scope = $element = element = null
  exampleUser =
    id: 1
    name: 'John Doe'
    slug: 'john-doe'
    avatar: 'http://s3.amazonaws.com/com.theciviccommons.int/avatars/default/avatar_70.gif'

  beforeEach ->
    User =
      getUser: (id) ->
        exampleUser
    module 'civicDirectives', 'users/user.html', 'users/avatar.html', ($provide) ->
      $provide.value 'User', User
      return

  beforeEach(inject((_$compile_, _$rootScope_) ->
    $scope = _$rootScope_
    $compile = _$compile_
  ))

  describe 'User Directive',  ->
    anchor = null
    beforeEach ->
      element = $compile('<user id="1"></user>')($scope)
      $scope.$digest()
      anchor = angular.element(angular.element(element.children()).children())

    it 'links to the user on the civic commons', ->
      expect(anchor.attr('href')).toContain(exampleUser.slug)
      expect(anchor.text()).toEqual(exampleUser.name)

    it 'opens in a new window', ->
      expect(anchor.attr('target')).toEqual '_blank'

  describe 'User Avatar Directive',  ->
    anchor = null
    img = null
    beforeEach ->
      element = $compile('<user-avatar id="1"></user-avatar>')($scope)
      $scope.$digest()
      anchor = angular.element(angular.element(element.children()).children())
      img = angular.element(anchor.children())

    it 'contains an image link to the user on the civic commons', ->
      expect(anchor.attr('href')).toContain(exampleUser.slug)
      expect(img.attr('src')).toEqual(exampleUser.avatar)

    it 'opens in a new window', ->
      expect(anchor.attr('target')).toEqual '_blank'
