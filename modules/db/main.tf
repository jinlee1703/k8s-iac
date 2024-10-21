resource "kubernetes_namespace" "db" {
  metadata {
    name = "${var.prefix}-db-namespace"
  }
}

resource "kubernetes_service" "db" {
  metadata {
    name      = "${var.prefix}-db-service"
    namespace = kubernetes_namespace.db.metadata[0].name
  }
  spec {
    selector = {
      app = "${var.prefix}-db"
    }
    port {
      port        = 3306
      target_port = 3306
    }
    cluster_ip = "None"
  }
}

resource "kubernetes_config_map" "db_config" {
  metadata {
    name      = "${var.prefix}-db-config"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  data = {
    "my.cnf" = <<EOF
[mysqld]
bind-address=0.0.0.0
EOF
  }
}

resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "${var.prefix}-db-secret"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  data = {
    ROOT_PASSWORD = var.db_root_password
    USER          = var.db_username
    PASSWORD      = var.db_password
    DATABASE      = var.db_name
  }

  type = "Opaque"
}

resource "kubernetes_stateful_set" "db" {
  metadata {
    name      = "${var.prefix}-db"
    namespace = kubernetes_namespace.db.metadata[0].name
  }

  spec {
    service_name = kubernetes_service.db.metadata[0].name
    replicas     = var.db_replicas

    selector {
      match_labels = {
        app = "${var.prefix}-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.prefix}-db"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:5.7"

          port {
            container_port = 3306
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_secret.metadata[0].name
                key  = "ROOT_PASSWORD"
              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_secret.metadata[0].name
                key  = "USER"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_secret.metadata[0].name
                key  = "PASSWORD"
              }
            }
          }

          env {
            name = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_secret.metadata[0].name
                key  = "DATABASE"
              }
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/mysql"
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/mysql/conf.d"
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.db_config.metadata[0].name
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = var.storage_size
          }
        }
      }
    }
  }
}

output "db_service_name" {
  value = "${kubernetes_service.db.metadata[0].name}.${kubernetes_namespace.db.metadata[0].name}.svc.cluster.local"
}

output "db_connection_string" {
  value     = "mysql://${var.db_username}:${var.db_password}@${kubernetes_service.db.metadata[0].name}.${kubernetes_namespace.db.metadata[0].name}.svc.cluster.local:3306/${var.db_name}"
  sensitive = true
}
