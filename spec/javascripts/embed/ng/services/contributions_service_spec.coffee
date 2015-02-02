describe 'Services', ->
  describe 'Contribution', ->
    $httpBackend = Contribution = User = undefined

    beforeEach ->
      module 'civic.services'

    beforeEach inject((_$httpBackend_, _Contribution_, _CivicApi_, _User_) ->
      $httpBackend = _$httpBackend_
      CivicApi = _CivicApi_
      CivicApi.setVar 'contributable_type', 'conversations'
      CivicApi.setVar 'contributable_id', testData.conversation.slug
      Contribution = _Contribution_
      User = _User_
    )

    beforeEach ->
      $httpBackend
        .expectGET "/api/v1/conversations/#{testData.conversation.slug}/contributions"
        .respond contributions: testData.contributions.slice 0, 19

    beforeEach (done) ->
      spyOn User, 'get'
        .and.returnValue {}
      Contribution.index {}, (data, headers) ->
        done()
      $httpBackend.flush()

    describe "After contributions loaded", ->

      it 'Returns first 20 contributions', ->
        expect(Contribution.getContributions()).toEqualData testData.contributions.slice 0,19

      it 'Returns a single contribution', ->
        expect(Contribution.getContributionByIndex(0)).toEqualData testData.contributions[0]
        expect(Contribution.getContributionByIndex(1)).toEqualData testData.contributions[1]

      it 'Returns a child contribution', ->
        expect(Contribution.getContributionByParentIndexAndIndex(3,0)).toEqualData testData.contributions[3].contributions[0]
        expect(Contribution.getContributionByParentIndexAndIndex(3,1)).toEqualData testData.contributions[3].contributions[1]
