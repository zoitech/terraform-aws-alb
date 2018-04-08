# Create S3 bucket policy "var.enable_alb_access_logs" is set to true
data "aws_iam_policy_document" "allow_alb_logging_access" {
  count = "${var.enable_alb_access_logs}"

  statement {
    sid    = "1"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.principle_account_id}:root"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_log_bucket_name}/${var.s3_log_bucket_Key_name}/*",
    ]
  }
}

# Create S3 bucket if "var.enable_alb_access_logs" is set to true
resource "aws_s3_bucket" "log_bucket" {
  count = "${var.enable_alb_access_logs}"

  bucket = "${var.s3_log_bucket_name}"
  acl    = "private"
  region = "${var.aws_region}"
  policy = "${data.aws_iam_policy_document.allow_alb_logging_access.json}"

  lifecycle_rule {
    enabled = "${var.lifecycle_rule_enabled}" #default = false
    id      = "${var.lifecycle_rule_id}"      #required #default = ""

    prefix = "${var.lifecycle_rule_prefix}" #default = whole bucket

    expiration {
      days = "${var.lifecycle_rule_expiration}" #default = 90
    }
  }
}

# Create S3 object key if "var.enable_alb_access_logs" is set to true
# The key to store the logs in
resource "aws_s3_bucket_object" "alb_access_logs_key" {
  count   = "${var.enable_alb_access_logs}"
  bucket  = "${aws_s3_bucket.log_bucket.id}"
  acl     = "private"
  key     = "${var.s3_log_bucket_Key_name}/"
  content = " "
}
