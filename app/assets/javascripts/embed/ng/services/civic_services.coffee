civicServices = angular.module 'civicServices', ['ngResource']

civicServices.factory 'CivicApi', ->
  civicApi =
    root: "/api/"
    version: "v1/"

  vars = {}

  civicApi.base_path = ->
    "#{this.root}#{this.version}"
  civicApi.endpoint = (path) ->
    "#{this.root}#{this.version}#{path}"
  civicApi.getVar = (name) ->
    vars[name]
  civicApi.setVar = (name, value) ->
    vars[name] = value

  return civicApi
