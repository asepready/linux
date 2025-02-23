# add a repository (example below is bitnami)
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

#user-admin.yaml
echo '
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
' | tee $HOME/user-admin.yaml

#cluster-admin.yaml
echo '
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
' | tee $HOME/cluster-admin.yaml

#secret-admin.yaml
echo '
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: "admin-user"   
type: kubernetes.io/service-account-token 
' | tee $HOME/secret-admin.yaml

# create
kubectl apply -f user-admin.yaml
kubectl apply -f cluster-admin.yaml
kubectl apply -f secret-admin.yaml

# Generate 
kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 -d

# Forwarding
kubectl port-forward -n kubernetes-dashboard svc/kubernetes-dashboard-kong-proxy --address 0.0.0.0 8443:443