# local-dev-example-with-minikube


This repo demos a simple go app being deployed to a Kubernetes cluster using minikube, and demnstrated changing the code and re-deploying a new version.


## Requirements
- Clone this repo !
- Install [minikube](https://minikube.sigs.k8s.io/docs/start/)
- Install [docker cli](https://minikube.sigs.k8s.io/docs/tutorials/docker_desktop_replacement/) (Docker Desktop is not required, only docker cli would be sufficent)


## Build and Deploy app to minikube for first time !

1. Start minikube
    ```console
    minikube start
    ```

2. Point your terminal to minikube's Docker using `minikube docker-env`
    ```console
    # on mac or linux
    eval $(minikube docker-env)
    ```

    ```console
    # on windows powershell
    & minikube docker-env | Invoke-Expression
    ```

    Tip 1: if you close your terminal you would have re-point your docker-env.

    Tip 2: to verify your terminal is pointining to minikube's Docker you can run `minikube status` and it will show "docker-env: in-use"

4. Build Docker image inside minikube

    ```console
    docker build -t local/devex:v1 . 
    ```
4. Deploy to Kubernetes
    ```console
    kubectl apply -f deploy/k8s.yaml 
    ```
5. Accees the deployed service in your browser
    ```console
    minikube service local-devex-svc
    ```
    Tip: you can try `$ minikube service list` to see all exposed serivces.


## Iterative development (how to redeploy after a code change)

1. Make a change in the code (for example bump the version in main.go) 
2. Ensure you still pointing to minikube docker using `minikube docker-env`)
3. Delete and rebuild the docker image. 
    ```console
    $ docker rmi  local/devex:v1;docker build  -t local/devex:v1 .
    ```
4.  Delete old deployment and re-deploy to kubernetes
    ```console
    kubectl delete  -f deploy/k8s.yaml 
    kubectl apply  -f deploy/k8s.yaml 
    ```
5. Accees the deployed service in your browser
    ```console
    minikube service local-devex-svc
    ```
