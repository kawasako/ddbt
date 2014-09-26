express = require("express")
router = express.Router()
# validator = require('validator')
# aws = require("aws-sdk")
# aws.config.loadFromPath("./config/ddb.json")
# ddb = new aws.DynamoDB()
# sio = require("../sio")
Traffic = require("../models/Traffic")
Individual = require("../models/Individual")

router.get "/timeline", (req, res) ->
  res.render "timeline",
    title: "Traffic timeline"
  return

# router.get "/timeline/:id", (req, res) ->
#   ddb.query
#     TableName: "Traffics_staging"
#     Select: "ALL_ATTRIBUTES"
#     IndexName: "label_id-timestamp-index"
#     KeyConditions:
#       label_id:
#         ComparisonOperator: "EQ"
#         AttributeValueList: [ {"S": req.params.id } ]
#     ScanIndexForward: false
#   , (err, data)->
#     console.log data.Items
#     res.render "individual",
#       title: req.params.id
#       Traffics: data.Items
#     return
#   return

router.get "/api/traffic.json", (req, res) ->
  if req.query["timestamp"] && req.query["id"]
    timestamp = req.query["timestamp"]
    t = new Traffic
      id: req.query["id"]
    t.query
      Operator: "LT"
      ValueList: ["#{timestamp}"]
      Limit: "15"
    , (data)->
      json = JSON.stringify(data.Items)
      res.send(json)
      return
  json = JSON.stringify({})
  return

router.get "/api/individual.json", (req, res) ->
  if req.query["label_id"] && req.query["id"]
    timestamp = new Date().getTime()
    t = new Traffic { id: req.query["id"] }
    i = new Individual { id: req.query["label_id"] }
    i.queryScan (labels)->
      t.query
        Operator: "LT"
        ValueList: ["#{timestamp}"]
        IndexName: "label_id-timestamp-index"
        hashKeyName: "label_id"
        hashKey: req.query["label_id"]
      , (traffics)->
        json = {}
        json.labels = labels.Items
        json.traffics = traffics.Items
        json = JSON.stringify(json)
        res.send(json)
        return
  json = JSON.stringify({})
  return


# router.get "/monitor", (req, res) ->
#   _res = res
#   ddb.scan
#     TableName: "Record2"
#     Select: "ALL_ATTRIBUTES"
#     ScanFilter:
#       timestamp:
#         ComparisonOperator: "GT"
#         AttributeValueList: [ {"N": "#{new Date().getTime()-60000*15}" } ]
#   , (err, res)->
#     # console.log res.Items
#     resTmpData = [].slice.call(res.Items).sort (x, y)->
#       return parseInt(y.timestamp["N"]) - parseInt(x.timestamp["N"])
#     resData = {}
#     for data in resTmpData
#       id = data.id["S"]
#       delete data.id
#       if resData[id]
#         resData[id].push(data)
#       else
#         resData[id] = [data]
#     # console.log resData
#     _res.render "monitor",
#       title: "Hello. I  ddbt."
#       Items: resData
#   return

# router.get "/monitor/user", (req, res) ->
#   _res = res
#   uid = req.query.uid
#   if uid
#     ddb.query
#       TableName: "Record2"
#       Select: "ALL_ATTRIBUTES"
#       KeyConditions:
#         id:
#           ComparisonOperator: "EQ"
#           AttributeValueList: [ {"S": uid } ]
#       ScanIndexForward: false
#     , (err, res)->
#       app.redirect('monitor', '/monitor') if err
#       _res.render "user",
#         title: uid
#         Items: res.Items
#   else
#     app.redirect('monitor', '/monitor') if err
#   return

module.exports = router