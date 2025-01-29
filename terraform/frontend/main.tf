resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = var.namespace
    labels = {
      app = "frontend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          name  = "frontend"
          image = var.frontend_image
          port {
            container_port = var.frontend_port
          }
          env {
            name  = "REACT_APP_API_BASE_URL"
            value = var.api_base_url
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = var.frontend_port
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "frontend_ingress" {
  metadata {
    name      = "frontend-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
    }
  }
  spec {
    rule {
      host = "lilashop.com"
      http {
        path {
          backend {
            service_name = kubernetes_service.frontend_service.metadata[0].name
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
}


