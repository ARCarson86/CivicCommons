angular.module 'civicServices'
  .factory 'Contribution', ['$resource', 'CivicApi', 'User', ($resource, CivicApi, User) ->
    @page = 1
    @contributions = []
    observerCallbacks = []

    Contribution = $resource CivicApi.endpoint('conversations/:conversation_id/contributions/:id'),
      conversation_id: ->
        CivicApi.getVar 'conversation_id'
    ,
      query:
        method: 'GET'
        isArray: true
        cache: true
      save:
        method: 'POST'
        cache: false
        transformResponse: (data, headersGetter) =>
          contribution = JSON.parse data
          if contribution.parent_id is null
            @contributions.unshift(contribution)
          else
            parentIndex = _.findIndex @contributions, id: contribution.parent_id
            @contributions[parentIndex].contributions.push contribution
          Contribution.notifyObservers()
          return contribution

    Contribution.index = (params = {}, success = null, failure = null) =>
      conts = Contribution.query params, (data, headers) =>
        @contributions = @contributions.concat data
        Contribution.notifyObservers()
        (success || Function())(data,headers)
      , failure

    Contribution.getContributionByParentIndexAndIndex = (parentIndex, index) =>
      @contributions[parentIndex].contributions[index]

    Contribution.getContributionByIndex = (index) =>
      @contributions[index]

    Contribution.registerObserverCallback = (callback) ->
      observerCallbacks.push callback

    Contribution.notifyObservers = ->
      angular.forEach observerCallbacks, (callback) ->
        (callback || Function())()

    Contribution.getContributions = =>
      @contributions

    Contribution.loadMore = (success, failure) =>
      Contribution.index page: ++@page, success, failure

    Contribution.prototype.construct = ->
      User.get(this.owner_id).then (data) =>
        @author = data
      if @contributions
        for contribution, i in @contributions
          @contributions[i] = new Contribution contribution

    return Contribution

  ]
