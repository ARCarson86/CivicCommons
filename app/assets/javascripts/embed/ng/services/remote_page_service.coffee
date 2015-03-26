angular.module 'civic.services'
  .factory 'RemotePage', ['$resource', 'CivicApi', ($resource, CivicApi) ->
    @observerCallbacks = []
    RemotePage = $resource CivicApi.endpoint('remote_pages/:id'), {},
      get:
        transformResponse: (data, headers) =>
          responseData = angular.fromJson data
          RemotePage.current_page = if responseData?.id then new RemotePage(responseData) else null
          RemotePage.notifyObservers RemotePage.current_page
          RemotePage.current_page
        params:
          remote_page_url: ->
            CivicApi.getVar 'conversation_id'

    RemotePage.registerObserverCallback = (callback) =>
      @observerCallbacks.push callback
      (callback || Function())(RemotePage.current_page) if RemotePage.current_page

    RemotePage.notifyObservers = (current_page) =>
      angular.forEach @observerCallbacks, (callback) ->
        (callback || Function())(current_page)

    RemotePage
  ]

