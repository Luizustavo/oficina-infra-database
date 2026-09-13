variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "sa-east-1"
}

variable "aws_profile" {
  description = "Named AWS CLI profile for local runs. Leave empty in CI, where credentials come from the environment."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name prefix used to tag and name all resources"
  type        = string
  default     = "oficina-backend"
}

variable "state_bucket" {
  description = "S3 bucket holding the Terraform state of every infra repo — created by oficina-infra-k8s/scripts/bootstrap-backend.sh"
  type        = string
  default     = "oficina-backend-tfstate-765465309229"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_engine_version" {
  description = "Postgres engine version for RDS"
  type        = string
  default     = "16"
}

variable "db_name" {
  description = "Initial database name created on the RDS instance"
  type        = string
  default     = "oficina_db"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "oficina_user"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS, in GB"
  type        = number
  default     = 20
}
