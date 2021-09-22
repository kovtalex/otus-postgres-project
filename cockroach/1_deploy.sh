#!/bin/bash

GOOGLE_PROJECT_ID=postgres2021

context[0]=gke_${GOOGLE_PROJECT_ID}_europe-north1_tf-region1
context[1]=gke_${GOOGLE_PROJECT_ID}_europe-west1_tf-region2
context[2]=gke_${GOOGLE_PROJECT_ID}_europe-central2_tf-region3

region[0]=europe-north1
region[1]=europe-west1
region[2]=europe-central2


for index in ${!region[*]}
do
  # Применение манифестов ModRules
  kubectl wait --for=condition=Ready --timeout=60s pod -l app.kubernetes.io/component=kubemod-operator --namespace kubemod-system --context ${context[$index]}
  kubectl apply -f ./modrules-${region[$index]}.yaml --namespace ${region[$index]} --context ${context[$index]}

  # Деплой cockroach
  kubectl apply -f ./external-name-svc-${region[$index]}.yaml --context ${context[$index]}
  kubectl apply -f ./dns-configmap-${region[$index]}.yaml --context ${context[$index]}

  kubectl delete pods -l k8s-app=kube-dns --namespace kube-system --context ${context[$index]}

  kubectl wait --for=condition=Ready --timeout=60s pod -l k8s-app=kube-dns --namespace kube-system --context ${context[$index]}
  
  kubectl apply -f ./cockroachdb-statefulset-${region[$index]}.yaml --namespace ${region[$index]} --context ${context[$index]} 

  kubectl wait --for=condition=Initialized --timeout=60s pod -l app=cockroachdb --namespace ${region[$index]} --context ${context[$index]}
done

sleep 30
kubectl apply -f cluster-init-secure.yaml --namespace europe-central2

sleep 5
kubectl apply -f client-secure.yaml --namespace europe-central2
kubectl wait --for=condition=Ready --timeout=60s pod -l app=cockroachdb-client --namespace europe-central2

sleep 30
kubectl exec -it --namespace europe-central2 cockroachdb-client-secure -- ./cockroach --certs-dir /cockroach-certs --host cockroachdb-public node status

for index in ${!region[*]}
do
  kubectl apply -f cockroachdb-app-secure.yaml --namespace ${region[$index]} --context ${context[$index]}
done
