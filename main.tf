terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path    = "~/.kube/config"
  config_context = "k3d-test-cluster"
}

locals {
  nginx_app_label = "NginxMetal"
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-metal"
    labels = {
      app = "NginxMetal"
    }
  }

  spec {
    replicas = 5
    selector {
      match_labels = {
        app = local.nginx_app_label
      }
    }
    template {
      metadata {
        labels = {
          app = local.nginx_app_label
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "128Mi"
            }
            requests = {
              cpu    = "0.25"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-metal-svc"
  }
  spec {
    selector = {
      app = local.nginx_app_label
    }
    
    port {
      port = "80"
      target_port = "80"
      protocol = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = kubernetes_service.nginx.metadata[0].name
              port {
                number = 80
              }
            }
          }
          path = "/"
          path_type = "Prefix"
        }
      }
    }
  }
}

