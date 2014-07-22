civicServices = angular.module 'civicServices', ['ngResource']

civicServices.factory 'CivicApi', [ ->
  root: "/api/"
  version: "v1/"
  base_path: ->
    "#{this.root}#{this.version}"
  endpoint: (path) ->
    "#{this.root}#{this.version}#{path}"

]
