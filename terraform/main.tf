# UGC Ownership Table
module "dynamodb_table_ugc_ownership" {
  source  = "cloudposse/dynamodb/aws"
  version = "0.32.0"

  namespace    = var.namespace
  stage        = var.stage
  environment  = var.environment
  name         = "ownership"
  hash_key     = "OwnershipID"
  billing_mode = var.dynamodb_billing_mode

  global_secondary_index_map = [
    {
      name            = "OwnerIDIndex"
      hash_key        = "OwnerID"
      range_key       = null
      projection_type = "ALL"
      # capacities are not required for GSI but the schema requires them
      read_capacity  = null
      write_capacity = null
      # non_key_attributes must be set to null if the projection_type is "ALL"
      non_key_attributes = null
    }
  ]

  dynamodb_attributes = [
    {
      name = "OwnershipID"
      type = "S"
    },
    {
      name = "OwnerID"
      type = "S"
    }
  ]
}