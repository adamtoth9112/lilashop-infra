terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "kubernetes" {
  host = "https://192.168.49.2:8443"
  config_path = "~/.kube/config"
  config_context = "minikube"
}

module "namespace" {
  source = "./modules/namespace"
}

module "database" {
  source    = "./database"
  namespace = module.namespace.lilashop_namespace
}

module "backend" {
  source    = "./backend"
  namespace = module.namespace.lilashop_namespace
  backend_image = "lcadam/lilashop-backend:latest"
}

module "frontend" {
  source    = "./frontend"
  namespace = module.namespace.lilashop_namespace
  frontend_image = "lcadam/lilashop-frontend:latest"
}

