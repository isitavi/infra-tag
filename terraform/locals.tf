locals {
  env = terraform.workspace
  tf_common_env = {
    lt    = "lt"
    uat   = "uat"
    prod  = "prod"
    green = "prod"
  }
  common_env = local.tf_common_env[local.env]

  # SSM parameter values for different environments
  ssm_values = {
    uat  = {
      param1 = "securevalue-uat1"
      param2 = "securevalue-uat2"
      param3 = "securevalue-uat3"
      param4 = "securevalue-uat4"
    }
    prod = {
      param1 = "securevalue-prod1"
      param2 = "securevalue-prod2"
      param3 = "securevalue-prod3"
      param4 = "securevalue-prod4"
    }
  }

}