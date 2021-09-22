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

  ip=""
  while [ -z "$ip" ]; do
    ip=$(kubectl get svc/kube-dns-lb --namespace kube-system --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}" --context ${context[$index]})
    [ -z "$ip" ]
  done
  echo \"${region[$index]}'.svc.cluster.local": ["'$ip'"]'
done
