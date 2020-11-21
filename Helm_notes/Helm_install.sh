choco install kubernetes-helm

refreshenv

helm version --short
# v3.4.1+gc4e7485

kubectl config view
# apiVersion: v1
# clusters:
# - cluster:
#     certificate-authority-data: DATA+OMITTED
#     server: https://kubernetes.docker.internal:6443
#   name: docker-desktop
# - cluster:
#     certificate-authority-data: DATA+OMITTED
#     server: https://<>.us-east-1.linodelke.net:443
#   name: lke13444
# - cluster:
#     certificate-authority: C:\Users\lilyx\.minikube\ca.crt
#     server: https://172....
#   name: minikube
# contexts:
# - context:
#     cluster: docker-desktop
#     user: docker-desktop
#   name: docker-desktop
# - context:
#     cluster: minikube
#     namespace: default
#     user: minikube
#   name: minikube
# - context:
#     cluster: lke13444
#     namespace: default
#     user: lke13444-admin
#   name: ps-gsk
# current-context: minikube
# kind: Config
# preferences: {}
# users:
# - name: docker-desktop
#   user:
#     client-certificate-data: REDACTED
#     client-key-data: REDACTED
# - name: lke13444-admin
#   user:
#     token: REDACTED
# - name: minikube
#   user:
#     client-certificate: C:\Users\lilyx\.minikube\profiles\minikube\client.crt
#     client-key: C:\Users\lilyx\.minikube\profiles\minikube\client.key

# Install the official helm chart repository
helm repo add stable https://charts.helm.sh/stable
# "stable" has been added to your repositories

helm install demo-mysql stable/mysql

#WARNING: This chart is deprecated
# NAME: demo-mysql
# LAST DEPLOYED: Thu Nov 19 18:03:52 2020
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# NOTES:
# MySQL can be accessed via port 3306 on the following DNS name from within your cluster:
# demo-mysql.default.svc.cluster.local

# To get your root password run:

#     MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default demo-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

# To connect to your database:

# 1. Run an Ubuntu pod that you can use as a client:

#     kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash -il

# 2. Install the mysql client:

#     $ apt-get update && apt-get install mysql-client -y

# 3. Connect using the mysql cli, then provide your password:
#     $ mysql -h demo-mysql -p

# To connect to your database directly from outside the K8s cluster:
#     MYSQL_HOST=127.0.0.1
#     MYSQL_PORT=3306

#     # Execute the following command to route the connection:
#     kubectl port-forward svc/demo-mysql 3306

#     mysql -h ${MYSQL_HOST} -P${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD}

kubectl get all
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/demo-mysql-8674bf7d9b-967qq   1/1     Running   0          2m41s

# NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
# service/demo-mysql   ClusterIP   10.110.22.102   <none>        3306/TCP   2m41s
# service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP    4h24m

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/demo-mysql   1/1     1            1           2m41s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/demo-mysql-8674bf7d9b   1         1         1       2m41s

# uninstall
helm uninstall demo-mysql

# checks
kubectl get all
# config history
kubect get secret
# look at client side cache
helm env