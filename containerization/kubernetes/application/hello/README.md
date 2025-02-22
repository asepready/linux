Example: Deploying PHP Guestbook application with Redis
```sh
# Creating the Deployment
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-deployment.yaml
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-deployment.yaml
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml

kubectl get pods 
kubectl logs -f deployment/redis-leader
kubectl get pods -l app=guestbook -l tier=frontend

# Creating the Service
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-service.yaml
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-service.yaml
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml
kubectl get service

# Viewing the Frontend Service via LoadBalancer
kubectl port-forward svc/frontend 8080:80
kubectl get service frontend

# Scale the Web Frontend
kubectl scale deployment frontend --replicas=5
kubectl get pods

# Cleaning up
## delete all Pods, Deployments, and Services
kubectl delete deployment -l app=redis
kubectl delete service -l app=redis
kubectl delete deployment frontend
kubectl delete service frontend

## The response should look similar to this:
deployment.apps "redis-follower" deleted
deployment.apps "redis-leader" deleted
deployment.apps "frontend" deleted
service "frontend" deleted