angular.module 'civic.services'
  .factory 'Contribution', ['$filter', '$resource', '$rootScope', 'CivicApi', 'User', ($filter, $resource, $rootScope, CivicApi, User) ->
    @page = 1
    @contributions = []
    observerCallbacks = []

    permitted_params = [ 'content', 'parent_id', 'attachment', 'url' ]

    contributionJsonFromRequestObject = (requestObject) ->
      data = {}
      angular.forEach requestObject, (value, key) ->
        data[key] = value if key in permitted_params
      angular.toJson contribution: data

    Contribution = $resource CivicApi.endpoint(':contributable_type/:contributable_id/contributions/:id'),
      contributable_type: ->
        CivicApi.getVar 'contributable_type'
      contributable_id: ->
        CivicApi.getVar 'contributable_id'
      id: '@id'
    ,
      query:
        method: 'GET'
        isArray: true
        cache: true
        transformResponse: (data, headers) ->
          contributions = angular.fromJson data
          angular.forEach contributions, (item, i) ->
            contributions[i].content = $filter('linkTarget')(contributions[i].content, '_blank')
            contributions[i] = new Contribution item
            contributions[i].author = User.get(item.owner_id)
            angular.forEach item.contributions, (nested, nestedIndex) ->
              contributions[i].contributions[nestedIndex].content = $filter('linkTarget')(contributions[i].contributions[nestedIndex].content, '_blank')
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
        transformResponse: (data, headersGetter) =>
          contribution = new Contribution JSON.parse(data)
          contribution.author = User.get contribution.owner_id
          if contribution.parent_id is null
            parent = Contribution.find contribution.parent_id

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

    Contribution.find = (id) =>
      $filter('filter')(@contributions, id: id)[0]

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

    Contribution.prototype.reply = ->
      if @parent_id
        parent = Contribution.find(@parent_id)
        parent.replyActive = !parent.replyActive
      else
        @replyActive = !@replyActive
        console.log 'false', @parent_id


    return Contribution

  ]
