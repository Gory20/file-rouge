# Fichier : main.tf

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Déclaration du provider Kubernetes
provider "kubernetes" {
  config_path = "/home/gory/.kube/config"
}
