angular.module 'civic.services'
  .factory 'Contribution', ['$filter', '$resource', '$rootScope', 'CivicApi', 'User', ($filter, $resource, $rootScope, CivicApi, User) ->
    @page = 1
    @contributions = []
    @count = 0
    observerCallbacks = []

    permitted_params = [ 'content', 'parent_id', 'attachment', 'url' ]

    contributionJsonFromRequestObject = (requestObject) ->
      data = {}
      angular.forEach requestObject, (value, key) ->
        data[key] = value if key in permitted_params
      angular.toJson contribution: data

    contributionResourceFromData = (data) ->
      contribution = new Contribution data
      contribution.content = $filter('linkTarget')(contribution.content, '_blank')

      angular.forEach contribution.contributions, (nested, i) ->
        contribution.contributions[i] = contributionResourceFromData nested

      contribution

    Contribution = $resource CivicApi.endpoint(':contributable_type/:contributable_id/contributions/:id/:action'),
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
        transformResponse: (data, headers) =>
          responseData = angular.fromJson data
          contributions = responseData.contributions
          @count = responseData.total
          angular.forEach contributions, (item, i) ->
            contributions[i] = contributionResourceFromData item
          contributions

      create:
        method: 'POST'
        cache: false
        transformRequest: contributionJsonFromRequestObject
        transformResponse: (data, headersGetter) =>
          contribution = JSON.parse(data)
          return data if contribution.errors
          contribution = contributionResourceFromData contribution
          if contribution.parent_id is null
            @contributions.unshift(contribution)
          else
            parentIndex = _.findIndex @contributions, id: contribution.parent_id
            @contributions[parentIndex].contributions.push contribution
          Contribution.notifyObservers()
          return contribution

      flag:
        params: {
          action: 'flag'
        }
        method: 'POST'
        cache: false

      moderate:
        params: {
          action: 'moderate'
        }
        method: 'POST'
        cache: false

      toggle:
        params: {
          action: 'toggle_rating'
        }
        method: 'PUT'
        cache: false

      update:
        method: 'PUT'
        cache: false
        transformRequest: contributionJsonFromRequestObject
        transformResponse: (data, headersGetter) =>
          contribution = JSON.parse(data)
          return data if contribution.errors
          contribution = contributionResourceFromData contribution

          if contribution.parent_id is null
            contributionIndex = _.findIndex @contributions, id: contribution.id
            @contributions[contributionIndex] = contribution
          else
            parentIndex = _.findIndex @contributions, id: contribution.parent_id
            contributionIndex = _.findIndex @contributions[parentIndex].contributions, id: contribution.id
            @contributions[parentIndex].contributions[contributionIndex] = contribution

          Contribution.notifyObservers()

          return contribution

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

    Contribution.total = () =>
      @count

    Contribution.count = () =>
      @contributions.length


    Contribution.prototype.save = (params, success, failure) ->
      if @is_new_record()
        @$create(params, success, failure)
      else
        @$update(params, success, failure)

    Contribution.prototype.flag = (params, success, failure) ->
      contribution = new Contribution
        id: @id
      contribution.$flag params, success, failure

    Contribution.prototype.toggle = (params, success, failure) ->
      contribution = new Contribution
        id: @id
      contribution.$toggle params, success, failure

    Contribution.prototype.reply = ->
      if @parent_id
        parent = Contribution.find(@parent_id)
        parent.replyActive = !parent.replyActive
      else
        @replyActive = !@replyActive

    Contribution.prototype.is_new_record = ->
      not @id

    Contribution.prototype.editable = ->
      created_at = new Date @created_at
      now = new Date
      Math.round((now.getTime() - created_at.getTime()) / 1000 / 60) <= 30

    Contribution.prototype.author = ->
      User.get @owner_id

    return Contribution

  ]
