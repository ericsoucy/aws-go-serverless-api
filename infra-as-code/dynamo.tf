resource "aws_dynamodb_table" "ddbtable" {
  name             = "LambdaInGoUser"
  hash_key         = "email"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "email"
    type = "S"
  }
}