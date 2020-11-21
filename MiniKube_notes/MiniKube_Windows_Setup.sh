# In Windows Powershell as Admin:
choco install minikube

# start minikube
minikube start
# * minikube v1.15.1 on Microsoft Windows 10 Pro 10.0.18363 Build 18363
# * Starting control plane node minikube in cluster minikube
# * Pulling base image ...
# * Downloading Kubernetes v1.19.4 preload ...
#     > preloaded-images-k8s-v6-v1.19.4-docker-overlay2-amd64.tar.lz4: 486.35 MiB
# * Creating docker container (CPUs=2, Memory=1987MB) ...
# * Preparing Kubernetes v1.19.4 on Docker 19.03.13 ...
# * Verifying Kubernetes components...
# * Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

# inable ingress add-on
minikube addons enable ingress
# * Verifying ingress addon...
# * The 'ingress' addon is enabled

# Due to problems with ingress add-on
# https://github.com/kubernetes/minikube/issues/7332

minikube config set vm-driver hyperkit
minikube delete
minikube start
minikube addons enable ingress


minikube ip
# 172...

# in hosts file at C:\Windows\System32\drivers\etc, open Notepad as Admin:
172... frontend.minikube.local
172... backend.minikube.local


