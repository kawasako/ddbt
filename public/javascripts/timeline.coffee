app = angular.module("app", [])
socket = io.connect(location.host)

###
  Fillters
########################################################################

app.filter "toColorCode", ->
  (input)->
    t = ("abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789"); c = ""; i = 0
    while i < input.length
      c += t.indexOf(input.charAt(i)); i++
    c = parseInt(c).toString(16); cc = "#"; i = 0
    while i < 6
      cc += c.charAt(i); i++
    return cc

app.filter "isAccess", ->
  (input)->
    return if input then input else "アクセス"

app.filter "toIconClass", ->
  (input)->
    return if input then "action" else "traffic"

###
  Timelime
########################################################################

app.controller "timelineController", ($rootScope,$scope,$http)->
  $scope.id = "liptonchilled.com"
  $scope.names = []
  $scope.loading = false
  $scope.last = new Date().getTime()

  $scope.load = ->
    return false if $scope.loading
    $scope.loading = true
    $http
      method: "GET"
      url: "/api/traffic.json?id=#{$scope.id}&timestamp=#{$scope.last}"
    .success (data, status, headers, config)->
      if data.length > 0
        $scope.last = data[data.length-1].timestamp["N"]
        Array.prototype.push.apply($scope.names, data)
      setTimeout ->
        $scope.loading = false
      ,500 # Intarval limit
    .error (data, status, headers, config)->
      console.log status
      setTimeout ->
        $scope.loading = false
      ,500 # Intarval limit

  $scope.show = (label_id)->
    $rootScope.$broadcast "select_label_id", label_id

  socket.on "update", (data)->
    $scope.$apply ->
      $scope.names.unshift data

  $scope.load() if $scope.id # initialize

###
  Individual
########################################################################

app.controller "individualController", ($scope,$http)->
  $scope.id = "liptonchilled.com"
  $scope.label_id = ""
  $scope.labels = []
  $scope.names = []
  $scope.loading = false
  $scope.last = new Date().getTime()

  $scope.load = ->
    return false if $scope.loading || $scope.label_id == ""
    $scope.loading = true
    $http
      method: "GET"
      url: "/api/individual.json?id=#{$scope.id}&label_id=#{$scope.label_id}"
    .success (data, status, headers, config)->
      if data["traffics"].length > 0
        console.log data
        $scope.last = data["traffics"][data["traffics"].length-1].timestamp["N"]
        $scope.names = data["traffics"]
        $scope.labels = data["labels"]
      setTimeout ->
        $scope.loading = false
      ,500 # Intarval limit
    .error (data, status, headers, config)->
      setTimeout ->
        $scope.loading = false
      ,500 # Intarval limit

  $scope.$on "select_label_id", (event, label_id)->
    return false if $scope.label_id == label_id || $scope.loading
    $scope.label_id = label_id
    $scope.load()

  socket.on "update", (data)->
    if data.label_id["S"] == $scope.label_id
      $scope.$apply ->
        $scope.names.unshift data

  $scope.load() if $scope.label_id # initialize