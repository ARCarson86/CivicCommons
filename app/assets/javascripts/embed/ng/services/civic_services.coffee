civicServices = angular.module 'civic.services', ['ngResource']

civicServices.factory 'CivicApi', ->
  CivicApi =
    root: "/api/"
    version: "v1/"
    vars: {}
    base_path: ->
      [@root, @version].join ''
    endpoint: (path) ->
      [@root, @version, path].join ''
    getVar: (name, defaultValue) ->
      @vars[name] || defaultValue
    setVar: (name, value) ->
      @vars[name] = value

  return CivicApi
