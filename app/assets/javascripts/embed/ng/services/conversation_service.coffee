angular.module 'civic.services'
  .factory 'Conversation', ['$filter', '$resource', 'CivicApi', ($filter, $resource, CivicApi) ->
    Conversation = $resource CivicApi.endpoint('conversations/:id'), {},
      get:
        params:
          id: ->
            CivicApi.getVar 'conversation_id'
        transformResponse: (data, headers) ->
          conversation = angular.fromJson data
          conversation.summary = $filter('linkTarget')(conversation.summary, '_blank')
          conversation.starter = $filter('linkTarget')(conversation.starter, '_blank')
          CivicApi.setVar 'totalContributions', conversation.number_of_top_level_contributions
          new Conversation conversation

  ]
