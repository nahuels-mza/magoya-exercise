# Create a service
resource "kubernetes_service" "local_service" {
  metadata {
    name      = "local-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      App = "localhost"
    }
    port {
      port        = 80
      target_port = 3000
    }

    type = "NodePort"
  }
  depends_on = [kubernetes_namespace.local]
}
