resource "aws_dynamodb_table" "dynamodb_table_user_information" {
  name         = "UserInformation"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserID"

  #   List of attributes UserID, Username, Email, MobilePhone, RegistrationDate
  attribute {
    name = "UserID"
    type = "S"
  }

  attribute {
    name = "Username"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }

  attribute {
    name = "MobilePhone"
    type = "S"
  }

  global_secondary_index {
    hash_key        = "Email"
    name            = "EmailIndex"
    projection_type = "ALL"
  }

  global_secondary_index {
    hash_key        = "Username"
    name            = "UsernameIndex"
    projection_type = "ALL"
  }

  global_secondary_index {
    hash_key        = "MobilePhone"
    name            = "MobilePhoneIndex"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "dynamodb_table_user_balance" {
  name         = "UserBalance"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserID"
  range_key = "Currency"

  attribute {
    name = "UserID"
    type = "S"
  }

  attribute {
    name = "Currency"
    type = "S"
  }

}