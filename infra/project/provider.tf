# ################################################################################
# Terraform Block
# ================================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0" # 6.0~<7.0
    }
  }

  backend "s3" {
    bucket         = "bipa17-std01-terraform-state-bucket"               # 테라폼 상태파일을 저장할 버킷 이름
    key            = "TerraformState/Lab/ex7-resource/terraform.tfstate" # 버킷에서 테라폼 상태파일 저장 경로
    region         = "ap-northeast-1"
    dynamodb_table = "bipa17-std01-terraform-lock" # 락온 상태를 저장할 DynamoDB Table 이름
    encrypt        = true                          # 파일 암호화
  }
}


# ################################################################################
# Provider Block
# ================================================================================
provider "aws" {
  region = "ap-northeast-1"

  # 기본 태그 설정: Terraform으로 생성한 리소스들에 추가
  default_tags {
    tags = local.common_tags
  }
}


# ################################################################################
# S3 State Bucket
# ================================================================================

# 이미 존재하는 버킷이라 새로 생성하지 않음
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "bipa17-std01-terraform-state-bucket"
# }


# 기존 S3 버킷 버전 관리 활성화
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = "bipa17-std01-terraform-state-bucket"

  versioning_configuration {
    status = "Enabled"
  }
}


# ################################################################################
# DynamoDB Lock Table
# ================================================================================

# 이미 존재하는 DynamoDB 테이블이라 새로 생성하지 않음
# resource "aws_dynamodb_table" "terraform_lock" {
#   name         = "bipa17-std01-terraform-lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
