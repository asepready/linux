Example: Deploying PHP Guestbook application with Redis
```sh
# Creating the Deployment
kubectl apply -f https://k8s.io/examples/service/load-balancer-example.yaml

kubectl get pods 
kubectl get pods --output=wide

# Info
kubectl get deployments hello-world
kubectl describe deployments hello-world
kubectl get replicasets
kubectl describe replicasets

kubectl logs -f deployment/hello-world

# Creating the Service
kubectl expose deployment hello-world --type=LoadBalancer --name=hello-service
kubectl get service
kubectl get services hello-service
kubectl describe services hello-service

# Cleaning up
## delete all Pods, Deployments, and Services
kubectl delete deployment hello-world
kubectl delete service hello-service

## The response should look similar to this:
deployment.apps "hello-world" deleted
service "hello-service" deleted