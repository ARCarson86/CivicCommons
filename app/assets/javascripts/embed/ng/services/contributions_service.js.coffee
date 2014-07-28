civicServices = angular.module 'civicServices'

civicServices.factory 'Contribution', ['$resource', 'CivicApi', ($resource, CivicApi) ->
  contributions = {}
  Contribution = $resource CivicApi.endpoint('conversations/:conversation_id/contributions/:id'),
    conversation_id: ->
      CivicApi.getVar 'conversation_id'
  ,
    query:
      method: 'GET'
      cache: true

  Contribution.index = (params = {}, success = null, failure = null) ->
    conts = Contribution.query params, (data, headers) ->
      contributions = _.merge(contributions, data)
      (success)(data,headers)
    , failure

  Contribution.getContribution = (id, success = null, failure = null) ->
    contribution = contributions[id]

  return Contribution


]
