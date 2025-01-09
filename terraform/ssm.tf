# Create SSM parameters using the new KMS key and environment variables
resource "aws_ssm_parameter" "param1" {
  name   = "${local.env}-param1"
  type   = "SecureString"
  value  = local.ssm_values[local.env].param1
  key_id = aws_kms_key.ssm_key.arn
}

resource "aws_ssm_parameter" "param2" {
  name   = "${local.env}-param2"
  type   = "SecureString"
  value  = local.ssm_values[local.env].param2
  key_id = aws_kms_key.ssm_key.arn
}

resource "aws_ssm_parameter" "param3" {
  name   = "${local.env}-param3"
  type   = "SecureString"
  value  = local.ssm_values[local.env].param3
  key_id = aws_kms_key.ssm_key.arn
}

resource "aws_ssm_parameter" "param4" {
  name   = "${local.env}-param4"
  type   = "SecureString"
  value  = local.ssm_values[local.env].param4
  key_id = aws_kms_key.ssm_key.arn
}