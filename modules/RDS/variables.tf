variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "subnet_a_id" {
  type = string
}

variable "subnet_b_id" {
  type = string
}
