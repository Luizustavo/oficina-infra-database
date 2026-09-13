output "rds_endpoint" {
  description = "RDS host:port, without credentials"
  value       = aws_db_instance.main.endpoint
}

output "rds_address" {
  description = "RDS hostname, without port or credentials"
  value       = aws_db_instance.main.address
}

output "rds_security_group_id" {
  description = "Security group protecting the database"
  value       = aws_security_group.rds.id
}

output "database_url" {
  description = "Full DATABASE_URL for the app's Secret — read with `terraform output -raw database_url`, never commit it"
  value       = "postgresql://${var.db_username}:${random_password.db_password.result}@${aws_db_instance.main.address}:5432/${var.db_name}?sslmode=no-verify"
  sensitive   = true
}
