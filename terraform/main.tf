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


# Récupération du contenu YAML pour le déploiement PHP
resource  "kubernetes_manifest" "apache-deployment" {
  manifest = yamldecode(file("../app-deployment.yaml"))
  
}

# Récupération du contenu YAML pour le déploiement MySQL
resource "kubernetes_manifest" "db-base" {
  manifest = yamldecode(file("../db-deployment.yaml"))
  
}

# Récupération du contenu YAML pour le service PHP
resource  "kubernetes_manifest" "apache-service" {
 manifest = yamldecode(file("../app-service.yaml"))
 
}

# Récupération du contenu YAML pour le service MySQL
resource  "kubernetes_manifest" "db" {
  manifest= yamldecode(file("../db-service.yaml"))
  
}