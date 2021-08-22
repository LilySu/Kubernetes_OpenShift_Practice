
## Kubernetes Web UI

#### [https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml](https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml)

```kubectl describe secret -n kube-system```

#### copy token under "kubernetes.io/service-account-token" and paste into: [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login)



## Create a Pod Using a Yaml File

```kubectl create -f pluralsight/kubernetes_01/nginx.pod.yml --save-config```

#### Get Information on Pod

```kubectl describe pod my-nginx```

```kubectl get pod my-nginx -o yaml```

#### Create or Apply Changes if using Create, do --save-config

```kubectl apply -f nginx.pod.yml```

#### Get Into the Container of Pod, to Shell into it with TTY

```kubectl exec my-nginx -it sh```

#### Pops Open Editor to Edit Yaml

```kubectl edit -f nginx.pod.yml```

#### Delete Pod

```kubectl delete -f nginx.pod.yml```

