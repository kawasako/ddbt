DynamoDbModel = require("../models/DynamoDbModel")

class Individual extends DynamoDbModel
  TableName: "Individuals_production"
  HashKeyName: "id"
  HashKey: ""
  RangeKeyName: "label"
  RangeKey: ""
  Scheme:
    id: "S"
    label: "S"

module.exports = Individual