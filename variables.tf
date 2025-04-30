variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "webapp_ami_id" {
  description = "AMI ID for the web application instance"
  type        = string

}

variable "mysql_ami_id" {
  description = "AMI ID for the database instance"
  type        = string
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
  default     = "csye6225-cloud-ec2-key"
}

variable "db_volume_id" {
  description = "ID of the EBS volume to attach to the database instance"
  type        = string
  default     = "vol-0211cba3952008edd"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "recommend"
}

variable "database_password" {
  description = "Database password"
  type        = string
}

variable "database_username" {
  description = "Database user"
  type        = string
}

variable "webapp_secret_key" {
  description = "Secret key for Flask app"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "jocelynting.me"
}
