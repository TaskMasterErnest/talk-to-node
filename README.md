# talk-to-node

## An Overview
This project primarily is a micro-service application setup. A Java application that talks to a NodeJS application when a particular function is triggered.
Both applications are containerized into Docker containers and talk to each other over a network connecting both containers.
[insert java - nodejs communication photo]

## Environment Setup
For the initial project, the setup and installations were done manually and locked to only one cloud provider, GCP.
`**There will be instructions to incorporate IaC, multiple cloud providers, configuration management and different cluster configurations**`

### Setting Up Cloud Environment
First, create a Google Cloud Account (for the free $300 credits) and set up a project environment. For additional convenience, install the Google Cloud CLI so you can work with bash scripts from the terminal.
A best practice will be to create SSH keys for your Global and Project Accounts in Google Cloud, [watch this video], this will make connecting to your cluster from your terminal fast, safe and secure.
With the script below, you get the following:
1. a zone in which all your computing is done, can be changed.
2. a firewall rule to regulate traffic flow into and out of the compute zone
3. a static IP address
4. a Google Cloud instance / VM to which we attach the static IP address
``` Bash
#Set Compute Zone 
gcloud config set compute/zone us-central1-a

#Create ALLOW ALL Ingress Rule 
gcloud compute firewall-rules create allow-all \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=all \
--source-ranges=0.0.0.0/0 \
--target-tags=allow-all

#Create a Static IP to use it as a GCE External IP Address 
gcloud compute addresses create static-ip --region=us-central1

#Fetch the Static IP 
gcloud compute addresses describe static-ip --region=us-central1

#Create GCE Instance 
gcloud compute instances create admin-server --zone=us-central1-a \
--image=ubuntu-2004-focal-v20230302 \
--image-project=ubuntu-os-cloud \
--machine-type=e2-standard-4 \
--address= # put in the static-ip here
--network-tier=PREMIUM \
--boot-disk-size=100GB \
--tags=allow-all

```

If you followed the video and created SSH keys and passed them into your GCP account, especially for the Project (not Global) account, you can simply ssh into the server using a command like this: `ssh -i ~/gcp_keys/admin-server admin-server@<ip-address>`.

### Installing Kubernetes with kubeadm, containerd and Weave-Net
Here, we will install Kubernetes the hard way using kubeadm and utilizing containerd as the runtime. Then, we install WeaveNet as the underlying network Kubernetes will use.

I recommend that these commands be carried out by hand so as to catch any unusual things that might pop up.

1. Check required ports that will be needed for Kubernetes components to communicate with each other:
	- this will require these ports to be open.
```bash
nc 127.0.0.1 6443
```
2. Enable iptables Bridged Traffic on all the Nodes
```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```
3. Set up the Docker engine for the container runtime (containerd) [updated version](https://docs.docker.com/engine/install/ubuntu/)
```bash
#remove old versions of Docker in the workspace
sudo apt-get remove docker docker-engine docker.io containerd runc

#update apt and install packages to allow it to use a repo over HTTPS
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg

#Add the official Docker GPP key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

#Set up the repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#update the apt package
sudo apt-get update -y

#install the Docker engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#start and enable docker
sudo systemctl start docker
sudo systemctl enable docker
```

In production, only these ports are needed to be open for Kubernetes to use:
```bash
The following TCP ports are used by Kubernetes control plane components:

    Port 6443 – Kubernetes API server
    Ports 2379-2380 – etcd server client API
    Port 10250 – Kubelet API
    Port 10259 – kube-scheduler
    Port 10257 – kube-controller manager

The following TCP ports are used by Kubernetes nodes:

    Port 10250 – Kubelet API
    Ports 30000-32767 – NodePort Services

```
4. Bootstrapping kubeadm. [official documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
	- for this, in this demo case, all the ports must be open to be used by Kubernetes.
	- Setting up kubeadm, kubelet and kubectl. 
```bash
#access only the kubernetes website to set up the kubeadm, kubelet and kubectl

#update apt package and install packages needed to be used by Kubernetes
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl

#download the Google Cloud Public signing key
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

#new..works better
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | 
sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```
4. update and install kubeadm, kubelet and kubectl
```bash
sudo apt-get update -y
sudo apt-get install -y kubelet=1.26.1-00 kubectl=1.26.1-00 kubeadm=1.26.1-00
sudo apt-mark hold kubelet kubeadm kubectl

#verify the installation
kubectl version --short
kubeadm version
kubelet --version

# next step will be to configure a cgroup driver. We are using the docker runtime so this is not needed.
```
5. Initialize Kubeadm [documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
```bash
#first remove this file 
sudo rm /etc/containerd/config.toml

#restart containerd
sudo systemctl restart containerd

#the only command needed to run this is this:
sudo kubeadm init

#run the commands to start the cluster
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

```
6.  Install WeaveNet for CNI
```bash
#apply this file to install the CNI
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
- Check if this CNI is running by checking the pods in the kube-system
	- the coreDNS pods and the weave-net pod should be running.
```bash
kubectl get po -n kube-system
```

7. For this demo, we need the master node untainted in order to schedule pods on it. Untaint using this command:
```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

#another method is to get the taints on the node and run the taint command to untaint it
kubectl get nodes
kubectl describe nodes <node-name> | grep -i taint
#this gives an output
kubectl taint node <node-name> <taint-output>
#to untaint put a dash at the end of the taint output to untaint the node.
```

At this point, you have the following things running on the server; Kubernetes, Docker, an underlying runtime using Containerd and an underlying network using Weave.

### Installing Jenkins and a few more essentials
Again, for this demo, it is a one-node cluster hosting our Kubernetes cluster and also going to be home to the Jenkins server.
Here, we install Jenkins, jquery, Maven, color prompt for the terminal and some other essentials

```bash
# get color prompt in code 
PS1='\[\e[01;36m\]\u\[\e[01;37m\]@\[\e[01;33m\]\H\[\e[01;37m\]:\[\e[01;32m\]\w\[\e[01;37m\]\$\[\033[0;37m\] '
echo "PS1='\[\e[01;36m\]\u\[\e[01;37m\]@\[\e[01;33m\]\H\[\e[01;37m\]:\[\e[01;32m\]\w\[\e[01;37m\]\$\[\033[0;37m\] '" >> ~/.bashrc
sed -i '1s/^/force_color_prompt=yes\n/' ~/.bashrc
source ~/.bashrc

#install these
sudo apt-get update -y
sudo apt-get install -y vim build-essential jq python3-pip
sudo pip3 install jc

#get UUID of VM
sudo jc dmidecode | jq .[1].values.uuid -r

#install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt-get install -y jenkins

# start Docker and Jenkins services
sudo systemctl daemon-reload
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service
sudo usermod -a -G docker jenkins
echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```
- changing the port on which Jenkins listens to to port 8090
```bash
# jenkins listens on port 8080 automatically
# to change that, you need to get the location of the Jenkins service
# change the port number there and restart the service
sudo vim /lib/systemd/system/jenkins.service
sudo systemctl daemon-reload
sudo systemctl restart jenkins.service
sudo systemctl status jenkins.service

```

Install Java 17, the demo will not work without this version installed. The manual method in this [article](https://www.rosehosting.com/blog/how-to-install-java-17-lts-on-ubuntu-20-04/) is particularly helpful.

## Implementing Shift-Left Security
The essence of DevSecOps is that security is an integral part of the DevOps pipeline process from development to production.
Here is how the shift-left principle is implemented in this demo:
- development - usage of pre-publish hooks
- testing -  unit testing, mutation testing, SAST (Static Application Security Testing)
- image build - dependency scanning, container-image scanning, Dockerfile scanning
- deployment (staging) - integration testing
- deployment (production) - runtime config validation, DAST (Dynamic Application Security Testing)

### Setting up Jenkins Plugins
These are the key plugins that are used in the demo. The instructions to install and use these plugins are on the Jenkins plugins documentation site.

| Plugin           | Installation & Usage                                                                                                                                                      |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| perfomance       | [link](https://plugins.jenkins.io/performance/)                                                                                                                           |
| docker-workflow  | essentially, you need the docker pipeline, here's some [inspiration](https://medium.com/@gustavo.guss/jenkins-building-docker-image-and-sending-to-registry-64b84ea45ee9) |
| dependency-check | [link](https://plugins.jenkins.io/dependency-check-jenkins-plugin/)                                                                                                       |
| blueocean        | [link](https://plugins.jenkins.io/blueocean/)                                                                                                                             |
| jacoco           | [link](https://plugins.jenkins.io/jacoco/)                                                                                                                                |
| slack            | not recommended unless you have a slack library                                                                                                                           |
| sonar            | [link](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner-for-maven/)                                                              |
| pitmutation      | [link](https://plugins.jenkins.io/pitmutation/)                                                                                                                           |
| kubernetes-cli   | [link](https://www.rosehosting.com/blog/how-to-install-java-17-lts-on-ubuntu-20-04/)                                                                                      |
| pipeline stage view                 |     [link](https://plugins.jenkins.io/pipeline-stage-view/)                                                                                                                                                                      |
|                  |                                                                                                                                                                           |

### Setting up SonarQube scanner
Here, we use the docker version of the SonarQube scanner. The container has to be running and configured to port 9000.
`docker run -d --sonarqube -p 9000:9000 sonarqube`.
This article [here](https://funnelgarden.com/sonarqube-jenkins-docker/) walks through the process to set up Sonarqube to work with Jenkins.

The tooling used in this demo are:
- Talisman [add link]
- OWASP Dependency Check & Zed Attack Proxy (ZAP) [add link]
- OPA Conftest [add link]
- Trivy [add link]
- Kubesec [add link]
- Kube-bench [add link]
Do not bother trying to install these tools manually. They are either Docker containers or APIs that are reached and made available automatically when called.

### Running The Pipeline
In order to run this pipeline in your VM, there are a few manual adjustments to make:
1. fork this repo
2. make sure to use your personal Docker registry to store the built images
3. run these commands to deploy the node-service in Kubernetes, `kubectl create deploy node-app --image ernestklu/node-service:v1` and `kubectl expose deploy node-app --name node-service --port 5000 --type ClusterIP`
4. make changes in the Jenkinsfile; personalize the configuration. eg change the IP address, the Docker registry name, etc.
5. optional; link the forked repo to Jenkins via a webhook so the pipeline can be triggered automatically
6. create a pipeline job and configure the criteria under which it should run
