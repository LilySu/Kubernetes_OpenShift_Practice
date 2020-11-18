
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

# expose the hello-pod, the name registered with dns is hello-svc, will be exposed as a node port
# nodeport is the option that creates a port for the service on every cluster node
# this is the imperitive way because kubectl is the command to create the service, all configs
# are in command line
kubectl expose pod hello-pod --name=hello-svc --target-port=8080 --type=NodePort

# nodeport creates a cluster ip that it builds on top of.
# traffic hitting the node port at 30992 eventually get passed on as the cluter ip
# we can hit any node with the port 30992 to reach the web server

# take a look at services
kubectl get svc
# sample output:
# NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
# hello-svc    NodePort    10.128.15.7   <none>        8080:30992/TCP   9s
# kubernetes   ClusterIP   10.128.0.1    <none>        443/TCP          25h

# kubernetes in the name above is a systems service that exposes the api inside the cluster

# by default node ports are allocated by kubernetes in the range 30000 and 32767
# this port is mapped cluster-wide on every node. You can hit any node on the node port.

kubectl delete svc hello-svc

# apply service configurations from file
kubectl apply -f svc-nodeport.yml

$ kubectl describe svc ps-nodeport
# Name:                     ps-nodeport
# Namespace:                default
# Labels:                   <none>
# Annotations:              <none>
# Selector:                 app=web
# Type:                     NodePort
# IP:                       10.128.171.42 # cluster ip
# Port:                     <unset>  80/TCP # internal cluster port if accessing from inside the cluster
# TargetPort:               8080/TCP # apps listening on inside pods and containers
# NodePort:                 <unset>  31111/TCP # port we hit nodes from the outside
# Endpoints:                10.2.1.4:8080 # list of healthy pod ip's that the service will send traffic to - any pod in the cluster that matches the label selector
# Session Affinity:         None
# External Traffic Policy:  Cluster
# Events:                   <none>

kubectl apply -f svc-lb.yml

kubectl get svc

# NAME          TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)        AGE
# kubernetes    ClusterIP      10.128.0.1      <none>            443/TCP        43h
# ps-lb         LoadBalancer   10.128.19.165   104.237.148.179   80:31294/TCP   17s
# ps-nodeport   NodePort       10.128.171.42   <none>            80:31111/TCP   23m

# kubernetes and cloud back-end have provisioned the load balancer
# 104.237.148.179 is the public IP of the load balancer already created.
# this only works with cloud service provided with supported load balancers
# 1. yaml posted to kubernetes
# 2. kubernetes sees that it is requesting a load balancer service, so
# it talks to the cloud that it is running on.
# 3. it provisions the load balancer with the public address, building everything
# required so that traffic hitting the load balancer on the right port get routed
# to the app running on our kubernetes cluster

kubectl apply -f deploy.yml

# since deployments are ojects in the api, we can inspect them as well
kubectl get deploy

# NAME         READY   UP-TO-DATE   AVAILABLE   AGE
# web-deploy   5/5     5            5           35s

# look at replica sets
kubectl get rs

# NAME                    DESIRED   CURRENT   READY   AGE
# web-deploy-6c5887d555   5         5         5       3m2s

# web-deploy-6c5887d555 is the crypto hash of the service

kubectl describe svc ps-lb
# Name:                     ps-lb
# Namespace:                default
# Labels:                   <none>
# Annotations:              <none>
# Selector:                 app=web # send traffic to each pod in cluster where label = web
# Type:                     LoadBalancer
# IP:                       10.128.19.165
# LoadBalancer Ingress:     104.237.148.179
# Port:                     <unset>  80/TCP
# TargetPort:               8080/TCP
# NodePort:                 <unset>  31294/TCP
# Endpoints:                10.2.1.4:8080,10.2.1.5:8080,10.2.1.6:8080 + 3 more...
# Session Affinity:         None
# External Traffic Policy:  Cluster
# Events:
#   Type    Reason                Age   From                Message
#   ----    ------                ----  ----                -------
#   Normal  EnsuringLoadBalancer  60m   service-controller  Ensuring load balancer
#   Normal  EnsuredLoadBalancer   60m   service-controller  Ensured load balancer


kubectl get pods --show-labels
# NAME                          READY   STATUS    RESTARTS   AGE    LABELS
# hello-pod                     1/1     Running   0          179m   app=web
# web-deploy-6c5887d555-7dsbm   1/1     Running   0          11m    app=web,pod-template-hash=6c5887d555
# web-deploy-6c5887d555-d2twl   1/1     Running   0          11m    app=web,pod-template-hash=6c5887d555
# web-deploy-6c5887d555-dd68n   1/1     Running   0          11m    app=web,pod-template-hash=6c5887d555
# web-deploy-6c5887d555-jwggb   1/1     Running   0          11m    app=web,pod-template-hash=6c5887d555
# web-deploy-6c5887d555-th2vb   1/1     Running   0          11m    app=web,pod-template-hash=6c5887d555

# get endpoints
kubectl get ep

# NAME          ENDPOINTS                                               AGE
# kubernetes    69.164.223.241:6443                                     44h
# ps-lb         10.2.1.4:8080,10.2.1.5:8080,10.2.1.6:8080 + 3 more...   67m
# ps-nodeport   10.2.1.4:8080,10.2.1.5:8080,10.2.1.6:8080 + 3 more...   91m

# anytime you create a service you create an associated endpoint object or endpoint slice objects
# this is the list of ips of our 5 replica pods: 10.2.1.4,10.2.1.5,10.2.1.6,10.2.2.2,10.2.2.3,10.2.2.4
kubectl describe ep ps-lb
# Name:         ps-lb
# Namespace:    default
# Labels:       <none>
# Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2020-11-18T19:16:12Z
# Subsets:
#   Addresses:          10.2.1.4,10.2.1.5,10.2.1.6,10.2.2.2,10.2.2.3,10.2.2.4
#   NotReadyAddresses:  <none>
#   Ports:
#     Name     Port  Protocol
#     ----     ----  --------
#     <unset>  8080  TCP

# Events:  <none>

# we have 5 running pods managed by a deployment controller and a replica set controller
# they are on the control plane watching the cluster matches our desired state of 5 pods

# if we delete one pod, or node, the replica set controller spins up a new one to make sure our
# desired state matches our current state - self-healing

# show which nodes pods are running on:
kubectl get pods -o wide
# NAME                          READY   STATUS    RESTARTS   AGE     IP         NODE                          NOMINATED NODE   READINESS GATES
# hello-pod                     1/1     Running   0          3h18m   10.2.1.4   lke13444-16560-5fb307df9555   <none>           <none>
# web-deploy-6c5887d555-7dsbm   1/1     Running   0          30m     10.2.1.6   lke13444-16560-5fb307df9555   <none>           <none>
# web-deploy-6c5887d555-d2twl   1/1     Running   0          30m     10.2.2.2   lke13444-16560-5fb307df6fbc   <none>           <none>
# web-deploy-6c5887d555-dd68n   1/1     Running   0          30m     10.2.2.4   lke13444-16560-5fb307df6fbc   <none>           <none>
# web-deploy-6c5887d555-jwggb   1/1     Running   0          30m     10.2.1.5   lke13444-16560-5fb307df9555   <none>           <none>
# web-deploy-6c5887d555-l4d8t   1/1     Running   0          106s    10.2.1.7   lke13444-16560-5fb307df9555   <none>           <none>

# check replication service
kubectl get rs

kubectl describe rs web-deploy-6c5887d555
# Name:           web-deploy-6c5887d555
# Namespace:      default
# Selector:       app=web,pod-template-hash=6c5887d555
# Labels:         app=web
#                 pod-template-hash=6c5887d555
# Annotations:    deployment.kubernetes.io/desired-replicas: 5
#                 deployment.kubernetes.io/max-replicas: 7
#                 deployment.kubernetes.io/revision: 1
# Controlled By:  Deployment/web-deploy
# Replicas:       5 current / 5 desired
# Pods Status:    5 Running / 0 Waiting / 0 Succeeded / 0 Failed
# Pod Template:
#   Labels:  app=web
#            pod-template-hash=6c5887d555
#   Containers:
#    hello-pod:
#     Image:        nigelpoulton/getting-started-k8s:1.0 # shows which version of the image it was managing replicas for
#     Port:         8080/TCP
#     Host Port:    0/TCP
#     Environment:  <none>
#     Mounts:       <none>
#   Volumes:        <none>
# Events:
#   Type    Reason            Age   From                   Message
#   ----    ------            ----  ----                   -------
#   Normal  SuccessfulCreate  59m   replicaset-controller  Created pod: web-deploy-6c5887d555-l4d8t

# watch the status of pods terminated and restarting during a rollout
kubectl get pods --watch

# initiate rollout
kubectl rollout status deploy web-deploy

# check replication service
kubectl get rs

# describe specific replication service
kubectl describe rs web-deploy-6c5887d555

# rollback to previous version:
kubectl rollout undo deploy web-deploy --to-revision=1





