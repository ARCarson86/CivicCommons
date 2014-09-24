angular.module 'civicServices'
  .factory 'Contribution', ['$resource', '$rootScope', 'CivicApi', 'User', ($resource, $rootScope, CivicApi, User) ->
    @page = 1
    @contributions = []
    observerCallbacks = []

    permitted_params = [
      "content"
    ]

    contributionJsonFromRequestObject = (requestObject) ->
      data = {}
      angular.forEach requestObject, (value, key) ->
        data[key] = value if key in allowed_params
      angular.toJson contribution: data

    Contribution = $resource CivicApi.endpoint('conversations/:conversation_id/contributions/:id'),
      conversation_id: ->
        CivicApi.getVar 'conversation_id'
      id: '@id'
    ,
      query:
        method: 'GET'
        isArray: true
        cache: true
        transformResponse: (data, headers) ->
          contributions = angular.fromJson data
          angular.forEach contributions, (item, i) ->
            contributions[i] = new Contribution item
            contributions[i].author = User.get(item.owner_id)
            angular.forEach item.contributions, (nested, nestedIndex) ->
              contributions[i].contributions[nestedIndex] = new Contribution nested
              contributions[i].contributions[nestedIndex].author = User.get(contributions[i].contributions[nestedIndex].owner_id)

          return contributions

      create:
        method: 'POST'
        cache: false
        transformRequest: contributionJsonFromRequestObject
        transformResponse: (data, headersGetter) =>
          contribution = new Contribution JSON.parse(data)
          contribution.author = User.get contribution.owner_id
          if contribution.parent_id is null
            @contributions.unshift(contribution)
          else
            parentIndex = _.findIndex @contributions, id: contribution.parent_id
            @contributions[parentIndex].contributions.push contribution
          Contribution.notifyObservers()
          return contribution

      update:
        method: 'PUT'
        cache: false
        transformRequest: contributionJsonFromRequestObject

    Contribution.index = (params = {}, success = null, failure = null) =>
      Contribution.query params, (data, headers) =>
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

    Contribution.prototype.is_new_record = ->
      !@id

    Contribution.prototype.save = (params, success, failure) ->
      if @is_new_record()
        @$create(params, success, failure)
      else
        @$update(params, success, failure)

    return Contribution

  ]
