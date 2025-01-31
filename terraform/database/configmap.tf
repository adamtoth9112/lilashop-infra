resource "kubernetes_config_map" "database_init_scripts" {
  metadata {
    name      = "database-init-scripts"
    namespace = var.namespace
  }
  data = {
    "schema.sql" = file("${path.module}/init-scripts/schema.sql")
  }
}
