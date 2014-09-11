describe 'User Directives', ->
  $compile = $scope = $element = element = null
  exampleContribution =
    id: 1
    content: "<p>Contribution Content</p>"
    created_at: "2014-07-09T11:46:49-04:00"
    parent_id: null
    owner_id: 1
    contributions: []

  exampleUser =
    id: 1
    name: 'John Doe'
    slug: 'john-doe'
    avatar: 'http://s3.amazonaws.com/com.theciviccommons.int/avatars/default/avatar_70.gif'

  beforeEach ->
    User =
      getUser: (id) ->
        exampleUser
    Contribution = {}
    module 'civicDirectives', 'civicHelpers', 'contributions/contribution.html', 'users/avatar.html', 'users/user.html', 'contributions/new.html', ($provide)->
      $provide.value 'User', User
      $provide.value 'Contribution', Contribution
      return

  beforeEach(inject((_$compile_, _$rootScope_) ->
    $compile = _$compile_
    $scope = _$rootScope_.$new()
    $scope.contribution = exampleContribution
  ))

  describe 'Contribution Directive', ->
    element = null
    beforeEach ->
      element = $compile('<div contribution="contribution"></div>')($scope)
      $scope.$apply()

    it 'contains the contribution content', ->
      expect(element.html()).toContain(exampleContribution.content)
