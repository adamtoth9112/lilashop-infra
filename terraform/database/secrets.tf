resource "kubernetes_secret" "database_secret" {
  metadata {
    name      = "database-credentials"
    namespace = var.namespace
  }
  data = {
    POSTGRES_DB       = var.db_name
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
  }
  type = "Opaque"
}
