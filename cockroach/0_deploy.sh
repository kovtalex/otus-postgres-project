#!/bin/bash

GOOGLE_PROJECT_ID=postgres2021

gcloud container clusters get-credentials tf-region1 --region europe-north1 --project ${GOOGLE_PROJECT_ID}
gcloud container clusters get-credentials tf-region2 --region europe-west1 --project ${GOOGLE_PROJECT_ID}
gcloud container clusters get-credentials tf-region3 --region europe-central2 --project ${GOOGLE_PROJECT_ID}


context[0]=gke_${GOOGLE_PROJECT_ID}_europe-north1_tf-region1
context[1]=gke_${GOOGLE_PROJECT_ID}_europe-west1_tf-region2
context[2]=gke_${GOOGLE_PROJECT_ID}_europe-central2_tf-region3

region[0]=europe-north1
region[1]=europe-west1
region[2]=europe-central2

mkdir ./certs

cockroach cert create-ca --certs-dir ./certs --ca-key certs/ca.key
cockroach cert create-client root --certs-dir ./certs --ca-key ./certs/ca.key

cockroach cert create-node --certs-dir ./certs --ca-key ./certs/ca.key localhost 127.0.0.1 \
  cockroachdb-public cockroachdb-public.default \*.cockroachdb \
  cockroachdb-public.${region[0]} cockroachdb-public.${region[0]}.svc.cluster.local \*.cockroachdb.${region[0]} \*.cockroachdb.${region[0]}.svc.cluster.local \
  cockroachdb-public.${region[1]} cockroachdb-public.${region[1]}.svc.cluster.local \*.cockroachdb.${region[1]} \*.cockroachdb.${region[1]}.svc.cluster.local \
  cockroachdb-public.${region[2]} cockroachdb-public.${region[2]}.svc.cluster.local \*.cockroachdb.${region[2]} \*.cockroachdb.${region[2]}.svc.cluster.local

for index in ${!region[*]}
do
  # Создание lb для kube-dns
  kubectl apply -f ./dns-lb.yaml --context ${context[$index]}
  
  # Создание неймспейсов с именем регионов
  kubectl create namespace ${region[$index]} --context ${context[$index]}
  
  # Создание секретов
  kubectl create secret generic cockroachdb.client.root --from-file ./certs --context ${context[$index]}
  kubectl create secret generic cockroachdb.client.root --namespace ${region[$index]} --from-file ./certs --context ${context[$index]}    
  kubectl create secret generic cockroachdb.node --namespace ${region[$index]} --from-file ./certs --context ${context[$index]}

  # Замена дефолтного storage class на ssd
  kubectl apply -f ./sc-pd-ssd.yaml --context ${context[$index]}
  kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}' --context ${context[$index]}
  kubectl patch storageclass pd-ssd-cockroachdb -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' --context ${context[$index]}

  # Установка Kubemod оператора
  kubectl label namespace kube-system admission.kubemod.io/ignore=true --overwrite --context ${context[$index]}
  kubectl apply -f https://raw.githubusercontent.com/kubemod/kubemod/v0.13.0/bundle.yaml --context ${context[$index]}
done
