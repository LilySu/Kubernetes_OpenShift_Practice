``` kubectl apply -f ./ --record ```
```
kubectl get all
```

```
NAME                            READY   STATUS              RESTARTS   
AGE
pod/my-nginx-5bb9b897c8-2khgl   1/1     Running             0          
7s
pod/my-nginx-5bb9b897c8-kzrv2   0/1     Terminating         0          
7s
pod/my-nginx-5bb9b897c8-plm2p   1/1     Running             1          
23h
pod/my-nginx-5bb9b897c8-qr6fc   1/1     Running             1          
23h
pod/my-nginx-79b79449f6-9k5g4   0/1     ContainerCreating   0          
7s
pod/my-nginx-79b79449f6-d6w2j   0/1     ContainerCreating   0          
7s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   
AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   
4d21h

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-nginx   3/4     2            3           23h

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/my-nginx-5bb9b897c8   3         3         3       23h
replicaset.apps/my-nginx-79b79449f6   2         2         0       7s
```

```
kubectl rollout status deployment my-nginx
```

```
deployment "my-nginx" successfully rolled out
```
