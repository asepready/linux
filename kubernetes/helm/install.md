# Install Packages
```sh
curl -O https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo bash ./get-helm-3
helm version
```
# Basic Usage of Helm.
```sh
# search charts by words in Helm Hub
helm search hub wordpress

# add a repository (example below is bitnami)
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# show repository list
helm repo list

# search charts by words in repository
helm search repo bitnami

# display description of a chart
# helm show [all|chart|readme|values] [chart name]
helm show chart bitnami/haproxy

# deploy application by specified chart
# helm install [any name] [chart name]
helm install haproxy bitnami/haproxy
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

# display deployed application list
helm list

# display the status of deployed application
helm status haproxy

# uninstall a deployed application
helm uninstall haproxy
```