variable "namespace" {}

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
                name = "postgres-secret"
                key  = "POSTGRES_DB"
              }
            }
          }
          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = "postgres-secret"
                key  = "POSTGRES_USER"
              }
            }
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "postgres-secret"
                key  = "POSTGRES_PASSWORD"
              }
            }
          }
          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }
        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

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
    type = "ClusterIP"
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = var.namespace
  }
  data = {
    POSTGRES_DB       = "lilashop_db"
    POSTGRES_USER     = "lilashop_user"
    POSTGRES_PASSWORD = "lilashop_password"
  }
  type = "Opaque"
}

