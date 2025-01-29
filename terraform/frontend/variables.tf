variable "namespace" {
  description = "The namespace where the frontend will be deployed"
  type        = string
}

variable "frontend_image" {
  description = "Docker image for the frontend"
  type        = string
  default     = "lcadam/lilashop-frontend:latest"
}

variable "frontend_port" {
  description = "Port exposed by the frontend container"
  type        = number
  default     = 80
}

variable "api_base_url" {
  description = "Base URL of the backend API"
  type        = string
  default     = "http://backend-service:8080/api"
}
