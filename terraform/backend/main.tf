resource "kubernetes_secret" "backend_secret" {
  metadata {
    name      = "backend-secret"
    namespace = var.namespace
  }
  data = {
    SPRING_DATASOURCE_URL      = var.database_url
    SPRING_DATASOURCE_USERNAME = var.database_user
    SPRING_DATASOURCE_PASSWORD = var.database_password
  }
  type = "Opaque"
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = var.namespace
    labels = {
      app = "backend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          name  = "backend"
          image = var.backend_image
          port {
            container_port = 8080
          }
          env {
            name = "SPRING_DATASOURCE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.backend_secret.metadata[0].name
                key  = "SPRING_DATASOURCE_URL"
              }
            }
          }
          env {
            name = "SPRING_DATASOURCE_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.backend_secret.metadata[0].name
                key  = "SPRING_DATASOURCE_USERNAME"
              }
            }
          }
          env {
            name = "SPRING_DATASOURCE_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.backend_secret.metadata[0].name
                key  = "SPRING_DATASOURCE_PASSWORD"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}


