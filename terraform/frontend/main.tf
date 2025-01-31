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
          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "default.conf"
          }
        }
        volume {
          name = "nginx-config"
          config_map {
            name = kubernetes_config_map.frontend_nginx_config.metadata[0].name
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

resource "kubernetes_ingress_v1" "frontend_ingress" {
  metadata {
    name      = "frontend-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "false"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "lilashop.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.frontend_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_config_map" "frontend_nginx_config" {
  metadata {
    name      = "frontend-nginx-config"
    namespace = var.namespace
  }
  data = {
    "default.conf" = <<EOF
server {
    listen 80;

    # Serve React static files
    root /usr/share/nginx/html;
    index index.html;

    # Handle React routing (SPA)
    location / {
        try_files $uri /index.html;
    }

    # Forward API requests to the backend **INSIDE K8s** (No more reverse proxy)
    location /api/ {
        proxy_pass http://backend-service:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Handle 404 errors by serving index.html
    error_page 404 /index.html;
}
EOF
  }
}



