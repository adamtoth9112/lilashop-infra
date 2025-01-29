output "frontend_service_name" {
  value = kubernetes_service.frontend_service.metadata[0].name
}

output "frontend_ingress_host" {
  value = "http://lilashop.com"
}
