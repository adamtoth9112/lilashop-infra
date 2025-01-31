output "database_service" {
  value = kubernetes_service.database_service.metadata[0].name
}
output "database_pvc" {
  value = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
}
