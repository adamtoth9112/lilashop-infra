resource "kubernetes_secret" "database_secret" {
  metadata {
    name      = "database-credentials"
    namespace = var.namespace
  }
  data = {
    POSTGRES_DB       = base64encode(var.db_name)
    POSTGRES_USER     = base64encode(var.db_user)
    POSTGRES_PASSWORD = base64encode(var.db_password)
  }
  type = "Opaque"
}
