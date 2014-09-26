express = require("express")
router = express.Router()
validator = require('validator')
# aws = require("aws-sdk")
# aws.config.loadFromPath("./config/ddb.json")
# ddb = new aws.DynamoDB()
fs = require("fs")
ddbt = fs.readFileSync('./ddbt.js', 'utf-8')
# Models
Traffic = require("../models/Traffic")
Individual = require("../models/Individual")

# GET home page.
router.get "/", (req, res) ->
  # t = new Traffic
  #   id: "localhost:4567"
  # t.query
  #   Operator: "BETWEEN"
  #   ValueList: ["#{new Date().getTime()-60000*100}","#{new Date().getTime()}"]
  # , (data)->
  #   console.log data
  # ddb.query
  #   TableName: "Traffics_staging"
  #   Select: "ALL_ATTRIBUTES"
  #   IndexName: "label_id-timestamp-index"
  #   KeyConditions:
  #     label_id:
  #       ComparisonOperator: "EQ"
  #       AttributeValueList: [ {"S": "xzBtEYN5I7ZBbTHRf90s3XPR" } ]
  #   ScanIndexForward: false
  # , (err, res)->
  #   console.log res


  res.render "index",
    title: "Hello. I am ddbt."
  return

router.get "/ddbt.gif", (req, res) ->
  if req.query.uid
    # query = req.query
    uid = validator.escape req.query.uid || null
    label = validator.escape req.query.label || null
    path = validator.escape req.query.path || null

    Item = {}
    Item["id"] = validator.escape decodeURIComponent(req.query.name) if req.query.name
    Item["label_id"] = uid
    Item["location"] = path
    Item["action"] = validator.escape req.query.action if req.query.action
    # Item["tags"] = validator.escape(req.query.tags).split(",") if req.query.tags
    Item["timestamp"] = "#{new Date().getTime()}"
    if req.query.tags
      Item["tags"] = validator.escape(req.query.tags).split(",").filter (x,i,self)->
        self.indexOf(x) is i

    if label
      i = new Individual
        id: uid
        label: label
      i.save()
    # save
    if path
      t = new Traffic(Item)
      i = t.save()
      # todo option vars（for timeline）
      sio.emit "update", i if Item["id"] == "test" # id設定しないと動かないよ


  buf = new Buffer("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7","base64")
  res.setHeader("Content-Type", "image/gif")
  res.setHeader("p3p", "CP='NOI ADM DEV PSAi OUR OTRo STP IND COM NAV DEM'")
  res.end(buf)
  return

router.get "/ddbt.js", (req, res) ->
  resFile = ddbt.replace "{{DDBT_HOST}}", req.headers.host
  res.setHeader("Content-Type", "text/javascript")
  res.setHeader("p3p", "CP='NOI ADM DEV PSAi OUR OTRo STP IND COM NAV DEM'")
  res.end(resFile)
  return

module.exports = router
