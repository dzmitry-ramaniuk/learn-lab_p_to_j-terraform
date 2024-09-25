resource "aws_cognito_user_pool" "user_pool_lab" {
  name = "lab_crypto"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = false
  }

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "lab_crypto_user_pool_client" {
  name            = "lab-crypto-pool-client"
  user_pool_id    = aws_cognito_user_pool.user_pool_lab.id
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}