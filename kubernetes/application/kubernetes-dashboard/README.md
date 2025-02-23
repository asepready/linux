Alternatif with helm package
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl apply -f dashboard-user.yaml
kubectl apply -f dashboard-clusterrolebinding.yaml
kubectl get secret $(kubectl get serviceaccount dashboard-user -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode

## identify resource
kubectl get deployments -n kubernetes-dashboard
kubectl get services -n kubernetes-dashboard
kubectl get pods -n kubernetes-dashboard
kubectl get secrets -n kubernetes-dashboard

## delete resource
kubectl delete deployment kubernetes-dashboard -n kubernetes-dashboard
kubectl delete deployment dashboard-metrics-scraper -n kubernetes-dashboard
kubectl delete service kubernetes-dashboard -n kubernetes-dashboard
kubectl delete service dashboard-metrics-scraper -n kubernetes-dashboard 

kubectl delete secret kubernetes-dashboard-certs -n kubernetes-dashboard
kubectl delete secret kubernetes-dashboard-csrf -n kubernetes-dashboard
kubectl delete secret kubernetes-dashboard-key-holder -n kubernetes-dashboard
