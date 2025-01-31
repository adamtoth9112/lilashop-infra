resource "kubernetes_deployment" "database" {
  metadata {
    name      = "database"
    namespace = var.namespace
    labels = {
      app = "database"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "database"
      }
    }
    template {
      metadata {
        labels = {
          app = "database"
        }
      }
      spec {
        container {
          name  = "database"
          image = "postgres:15"
          port {
            container_port = 5432
          }
          env {
            name = "POSTGRES_DB"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database_secret.metadata[0].name
                key  = "POSTGRES_DB"
              }
            }
          }
          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database_secret.metadata[0].name
                key  = "POSTGRES_USER"
              }
            }
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database_secret.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }
          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
          volume_mount {
            name       = "init-scripts"
            mount_path = "/docker-entrypoint-initdb.d"
          }
        }
        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
        volume {
          name = "init-scripts"
          config_map {
            name = kubernetes_config_map.database_init_scripts.metadata[0].name
          }
        }
      }
    }
  }
}