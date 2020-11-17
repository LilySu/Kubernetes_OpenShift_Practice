
docker image build -t lilysu25/getting-started-k8s:1.0 .

docker image push lilysu25/getting-started-k8s:1.0

kubectl cluster-info

# posts pod definition to cluster, which specifically involves:
# posts file to apiserver
# requests will be authenticated and authorized
# configuration will persist to the cluster store
# schedulare will assign a pod to a node
kubectl apply -f pod.yml

# shows state of all pods in cluster / namespace ( way to logically partition cluster)
kubectl get pods --watch
# get a wide display of columns
kubectl get pods -o wide

kubectl describe pods <name of pod>
kubectl describe pods hello-pod

kubectl delete pod <name of pod>
# or
kubectl delete -f <name of file>.yml

kubectl expose pod hello-pod --name=hello-svc --target-port=8080 --type=NodePort
