#!/bin/bash

set -e

echo "Iniciando deploy completo..."

# 1. Aplicar Terraform (infraestrutura AWS + EKS + S3 + IAM)
echo "Inicializando Terraform..."
cd infra
terraform init

echo "Aplicando Terraform para criar infraestrutura..."
terraform apply -auto-approve

# Capturando outputs do Terraform para configurar kubectl
CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION=$(terraform output -raw aws_region || echo "us-east-1")

echo "Configurando kubectl para o cluster EKS: $CLUSTER_NAME na região $REGION"
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME

# 2. Aplicar Kubernetes manifests
echo "Aplicando manifests Kubernetes (deployment e service)..."
kubectl apply -f ../k8s/deployment.yaml
kubectl apply -f ../k8s/service.yaml

echo "Deploy concluído com sucesso!"
