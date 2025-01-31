resource "kubernetes_service" "database_service" {
  metadata {
    name      = "database-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "database"
    }
    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }
  }
}
