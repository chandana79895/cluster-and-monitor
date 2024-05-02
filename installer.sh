#!/bin/bash

# Set Jenkins namespace
NAMESPACE="jenkins"

# Create namespace
kubectl create namespace $NAMESPACE

# Add Jenkins Helm repository
helm repo add jenkins https://charts.jenkins.io

# Update Helm repositories
helm repo update

# Install Jenkins using Helm
helm install jenkins -n $NAMESPACE jenkins/jenkins

# Wait for Jenkins to be ready
until kubectl get pods -n $NAMESPACE | grep "jenkins-" | grep "1/1" | grep "Running"; do
  echo "Waiting for Jenkins pods to be ready..."
  sleep 10
done

# Get Jenkins admin password
echo "Jenkins URL: http://$(kubectl get svc -n $NAMESPACE jenkins -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):8080"
echo "Jenkins Admin Password:"
kubectl exec -n $NAMESPACE -it $(kubectl get pods -n $NAMESPACE -l "app.kubernetes.io/component=jenkins-master" -o jsonpath="{.items[0].metadata.name}") cat /var/jenkins_home/secrets/initialAdminPassword
