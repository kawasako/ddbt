DynamoDbModel = require("../models/DynamoDbModel")

class Traffic extends DynamoDbModel
  TableName: "Traffics_production"
  HashKeyName: "id"
  HashKey: ""
  RangeKeyName: "timestamp"
  RangeKey: ""
  Scheme:
    id: "S"
    timestamp: "N"
    label_id: "S"
    location: "S"
    action: "S"
    tags: "SS"

module.exports = Traffic