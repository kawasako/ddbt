aws = require("aws-sdk")
aws.config.loadFromPath("./config/ddb.json")
ddb = new aws.DynamoDB()
validator = require('validator')

class DynamoDbModel
  TableName: ""
  HashKeyName: ""
  HashKey: ""
  RangeKeyName: ""
  RangeKey: ""
  Scheme: {}

  constructor: (@initialize)->
    @set(@initialize)
    @Item = {}
    for key, type of @Scheme
      if @initialize[key]
        @Item[key] = {}
        @Item[key][type] = @initialize[key]

  set: (@initialize)->
    @Key = {}
    @HashKey = @initialize[@HashKeyName] if @initialize[@HashKeyName]?
    @Key[@HashKeyName] = {}
    @Key[@HashKeyName][@Scheme[@HashKeyName]] = "#{@HashKey}"
    if @RangeKeyName && @initialize[@RangeKeyName]?
      @RangeKey = @initialize[@RangeKeyName]
      @Key[@RangeKeyName] = {}
      @Key[@RangeKeyName][@Scheme[@RangeKeyName]] = "#{@RangeKey}"
    return @Key

  save: (fn)->
    _this = @
    ddb.putItem
      TableName: _this.TableName
      Item: _this.Item
    ,(err, data)->
      if err then console.log err else
        fn(data) if fn
    return _this.Item

  update: (key,val,action,fn)->
    return false unless @Scheme[key]
    _this = @
    updateAttr = {}
    updateAttr[key] = { Value: {}, Action: "" }
    updateAttr[key]["Value"][_this.Scheme[key]] = "#{validator.escape val}"
    updateAttr[key]["Action"] = action
    ddb.updateItem
      TableName: _this.TableName
      Key: _this.Key
      AttributeUpdates: updateAttr
    ,(err, data)->
      if err then console.log err else
        fn(data) if fn
    return updateAttr

  query: (range,fn)->
    # Operator: ,ValueList:
    return false unless @RangeKeyName
    _this = @
    hashKey = if range["hashKey"] then range["hashKey"] else @HashKey
    hashKeyName = if range["hashKeyName"] then range["hashKeyName"] else @HashKeyName
    key = {}
    key[@Scheme[hashKeyName]] = hashKey
    queryKey = {}
    queryKey[hashKeyName] = { ComparisonOperator: "EQ", AttributeValueList: [key] }

    range["Limit"] = 99999 unless range["Limit"]
    queryKey[@RangeKeyName] = {}
    queryKey[@RangeKeyName] = { ComparisonOperator: range["Operator"], AttributeValueList: [] }
    for val in range["ValueList"]
      rangeKey = {}
      rangeKey[@Scheme[@RangeKeyName]] = "#{val}"
      queryKey[@RangeKeyName]["AttributeValueList"].push(rangeKey)

    postData =
      TableName: _this.TableName
      Select: "ALL_ATTRIBUTES"
      KeyConditions: queryKey
      ScanIndexForward: false
      Limit: range["Limit"]
    postData["IndexName"] = range["IndexName"] if range["IndexName"]

    ddb.query postData, (err, data)->
      if err then console.log err else
        fn(data) if fn
    return queryKey

  queryScan: (fn)->
    return false unless @RangeKeyName
    _this = @
    hashKey = @HashKey
    hashKeyName = @HashKeyName
    key = {}
    key[@Scheme[hashKeyName]] = hashKey
    queryKey = {}
    queryKey[hashKeyName] = { ComparisonOperator: "EQ", AttributeValueList: [key] }

    postData =
      TableName: _this.TableName
      Select: "ALL_ATTRIBUTES"
      KeyConditions: queryKey
      ScanIndexForward: false

    ddb.query postData, (err, data)->
      if err then console.log err else
        fn(data) if fn
    return queryKey

module.exports = DynamoDbModel