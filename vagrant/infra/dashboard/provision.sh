#!/usr/bin/env bash


DIR=/flumen/vagrant/infra/dashboard

VERSION="v2.1.0"

kubectl delete namespace kubernetes-dashboard
kubectl create namespace kubernetes-dashboard

kubectl apply -f "$DIR/service-account.yaml"

echo "Applying insecure role binding"
kubectl delete clusterrolebinding kubernetes-dashboard
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/dashboard/$VERSION/aio/deploy/alternative.yaml"
kubectl delete clusterrolebinding kubernetes-dashboard
kubectl apply -f "$DIR/ingress-route.yaml"
kubectl patch deployment kubernetes-dashboard --patch "$(cat "$DIR/insecure.deployment.patch.yaml")" -n kubernetes-dashboard -o yaml
kubectl apply -f "$DIR/insecure.cluster-role-binding.yaml"

