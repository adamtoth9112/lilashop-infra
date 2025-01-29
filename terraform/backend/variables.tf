variable "namespace" {
  description = "The namespace where the backend will be deployed"
  type        = string
}

variable "backend_image" {
  description = "Docker image for the backend"
  type        = string
  default     = "lcadam/lilashop-backend:latest"
}

variable "database_url" {
  description = "Database connection URL"
  type        = string
  default     = "r2dbc:postgresql://database-service:5432/lilashop_db"
}

variable "database_user" {
  description = "Database username"
  type        = string
  default     = "lilashop_user"
}

variable "database_password" {
  description = "Database password"
  type        = string
  default     = "lilashop_password"
}
