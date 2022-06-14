#!/usr/bin/sh env

helm install --namespace gitlab gitlab-runner gitlab-runner-0.1.37.tgz
helm install --namespace gitlab gitlab-runner -f values.yml gitlab/gitlab-runner
helm delete --namespace gitlab gitlab-runner
kubectl get all -n gitlab
kubetl describe $POD -n gitlab
kubetl logs $POD -n gitlab

# https://192.168.42.110:6443
