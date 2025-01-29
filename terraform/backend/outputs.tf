output "backend_service_name" {
  value = kubernetes_service.backend_service.metadata[0].name
}

output "backend_secret_name" {
  value = kubernetes_secret.backend_secret.metadata[0].name
}
