output "lilashop_namespace" {
  value = kubernetes_namespace.lilashop.metadata[0].name
}