#### Create a Deployment
save config grabs a snapshot of metadata

stores current properties in resource's annotations

```kubectl create -f nginx.deployment.yml --save-config```

deployment.apps/my-nginx created

``` kubectl get pods ```
```
NAME                        READY   STATUS    RESTARTS   AGE
my-nginx-5bb9b897c8-plm2p   1/1     Running   0          4m45s
my-nginx-5bb9b897c8-qr6fc   1/1     Running   0          4m45s
```


``` kubectl get all ```

```
NAME                            READY   STATUS    RESTARTS   AGE
pod/my-nginx-5bb9b897c8-plm2p   1/1     Running   0          5m36s
pod/my-nginx-5bb9b897c8-qr6fc   1/1     Running   0          5m36s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d22h

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-nginx   2/2     2            2           5m37s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/my-nginx-5bb9b897c8   2         2         2       5m36s
```

#### replicas in nginx.deployment.yml changed from 2 to 4

``` kubectl apply -f nginx.deployment.yml ```

deployment.apps/my-nginx configured

``` kubectl get pods ```

```
NAME                        READY   STATUS    RESTARTS   AGE
my-nginx-5bb9b897c8-5w6n4   1/1     Running   0          50s
my-nginx-5bb9b897c8-lxzts   1/1     Running   0          50s
my-nginx-5bb9b897c8-plm2p   1/1     Running   0          8m8s
my-nginx-5bb9b897c8-qr6fc   1/1     Running   0          8m8s
```

#### replicas in nginx.deployment.yml changed from 4 to 2