data "kubernetes_all_namespaces" "allns" {}

locals {
  ns-present = contains(data.kubernetes_all_namespaces.allns.namespaces, var.namespace)
}

resource "kubernetes_namespace" "local" {
  metadata {
    name = local.ns-present ? 0 : var.namespace
    labels = {
      my_label = var.label
    }

  }
}
