resource "aws_s3_bucket" "s3" {
  bucket        = var.s3bucket_state
  force_destroy = true
  tags = {
    Name = var.s3bucket_state
    Env  = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "pb" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  bucket     = aws_s3_bucket.s3.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    sid = "Allow Access"
    principals {
      identifiers = ["AWS"]
      type        = "*"
    }
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*",
    ]
  }
  statement {
    sid = "List Objects"
    principals {
      identifiers = ["AWS"]
      type        = "*"
    }
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.s3.arn,
    ]
  }
}
