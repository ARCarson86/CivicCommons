angular.module 'civic.services'
  .factory 'RemotePage', ['$resource', 'CivicApi', ($resource, CivicApi) ->
    RemotePage = $resource CivicApi.endpoint('remote_pages/:id'), {},
      get:
        params:
          remote_page_url: ->
            CivicApi.getVar 'conversation_id'
    return RemotePage
  ]

