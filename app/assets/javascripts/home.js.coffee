app = angular.module('Shorts', ['ngResource'])

# rails auth token
app.config ($httpProvider) ->
  authToken = $('meta[name="csrf-token"]').attr('content')
  $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = authToken

# controllers
app.controller 'ShortenUrlCtrl', ['$scope', 'UrlService', ($scope, UrlService) ->
  $scope.init = ->
    @urlService = new UrlService()

  $scope.shorten = (e) ->
    e.preventDefault()

    url = @urlService.create original: $scope.original, (u) ->
      $scope.original = ''
      $scope.url = u
  ]

# services
app.factory 'UrlService', ['$resource', ($resource) ->
  class UrlService
    constructor: () ->
      @queryService = $resource '/urls.json'
      @service = $resource '/urls/:id.json', id: '@id'

    create: (attrs, cb) ->
      new @service(url: attrs).$save (url) =>
        @makeHrefs url
        cb(url) if cb

    makeHrefs: (url) ->
      port = ''
      port = ":#{location.port}" if location.port
      url.href = "http://#{location.hostname}#{port}/#{url.short}"
      url.infohref = "#{url.href}+"

    all: ->
      @queryService.query()
  ]


# directives
app.directive 'httpPrefix', ->
  restrict: 'A'
  require: 'ngModel'

  link: (scope, element, attrs, controller) ->
    ensureHttpPrefix = (value) ->
      # need to add prefix if we don't have http:// prefix already AND we don't have part of it
      if value and not /^(http):\/\//i.test(value) and 'http://'.indexOf(value) is -1
        controller.$setViewValue 'http://' + value
        controller.$render()
        "http://#{value}"
      else
        value

    controller.$formatters.push ensureHttpPrefix
    controller.$parsers.splice 0, 0, ensureHttpPrefix
