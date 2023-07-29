terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "default" {
  name = "c2-master"
  wait_for_ready = true
  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    networking {
      api_server_address = "192.168.100.95"
      api_server_port = 6443
      pod_subnet = "10.240.0.0/16"
      service_subnet = "10.0.0.0/16"
    }
    node {
      role = "control-plane"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.27.3"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.27.3"
    }
  }
}

provider "kubectl" {
  host = "${kind_cluster.default.endpoint}"
  cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
  client_certificate = "${kind_cluster.default.client_certificate}"
  client_key = "${kind_cluster.default.client_key}"
}

data "kubectl_file_documents" "crds" {
  content = file("olm/crds.yaml")
}

resource "kubectl_manifest" "crds_apply" {
  for_each  = data.kubectl_file_documents.crds.manifests
  yaml_body = each.value
  wait = true
  server_side_apply = true
}

data "kubectl_file_documents" "olm" {
  content = file("olm/olm.yaml")
}

resource "kubectl_manifest" "olm_apply" {
  depends_on = [data.kubectl_file_documents.crds]
  for_each  = data.kubectl_file_documents.olm.manifests
  yaml_body = each.value
}

provider "helm" {
  kubernetes {
    host = "${kind_cluster.default.endpoint}"
    cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
    client_certificate = "${kind_cluster.default.client_certificate}"
    client_key = "${kind_cluster.default.client_key}"
  }
}

resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.35"
  create_namespace = true

  values = [
    file("argocd/application.yaml")
  ]
}
