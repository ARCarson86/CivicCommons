beforeEach ->
  jasmine.addMatchers
    toEqualData: (util, customEqualityTesters) ->
      compare: (actual, expected) ->
        result = {}
        result.pass = angular.equals actual, expected
        return result
