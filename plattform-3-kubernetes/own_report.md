# Building K8s

## Building up the platform together

Describe all steps building the cluster with commands. On which steps above did
you have technical problems? What was the problem? How did you solved it? If you
proceed to Part 3, how did you implement the load balancing? Make subparagraphs
for each point. Make this summary together in your group.

We wrote sh scripts for all exercises they can be found on
[GitHub](https://github.com/gideon-monterosa/cloud/tree/main/plattform-3-kubernetes)
and we will also past them here:

**K3S**

# k3s auf dem k3snode01 installieren (master)

sudo apt update && sudo apt upgrade -y

curl -sfL https://get.k3s.io | sh -s - server

# validate the installation

sudo systemctl status k3s sudo k3s kubectl get nodes

# kopiere den token

sudo cat /var/lib/rancher/k3s/server/node-token

# k3s auf dem k3snode02 installieren (agent)

sudo apt update && sudo apt upgrade -y

curl -sfL https://get.k3s.io | K3S_URL=https://86.119.44.24:6443 K3S_TOKEN=TOKEN
sh - # TOKEN durch den token ersetzen

# validate the installation

sudo systemctl status k3s-agent

# validate on the master

sudo k3s kubectl get nodes

# Tain auf dem master einrichten

sudo k3s kubectl taint node k3snode01 k3s-controlplane=true:NoSchedule sudo k3s
kubectl get nodes -o wide sudo k3s kubectl describe node k3snode01 | grep Taints

# example workload ausführen

sudo k3s kubectl create deployment hello-node
--image=registry.k8s.io/echoserver:1.4 sudo k3s kubectl get deployments sudo k3s
kubectl get pods -o wide

# Reschedule der workload

sudo k3s kubectl get pods sudo k3s kubectl delete pod pod-name # pod-name durch
den pod name ersetzen sudo k3s kubectl get pods -o wide

**K8S**

# update the machienes and install

sudo apt update && sudo apt upgrade -y sudo apt install -y containerd vim

# erstelle die konfigurationsdatei für containerd

sudo mkdir -p /etc/containerd sudo containerd config default | sudo tee
/etc/containerd/config.toml

# bearbeite die konfiguration

sudo vi /etc/containerd/config.toml

# [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]

# systemdcgroup = true

# restart

sudo systemctl restart containerd sudo systemctl enable containerd

# kubernetes repository auf allen maschinen einrichten

sudo apt-get update sudo apt-get install -y apt-transport-https ca-certificates
curl gnupg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg
--dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg sudo chmod 644
/etc/apt/keyrings/kubernetes-apt-keyring.gpg echo 'deb
[signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg]
https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee
/etc/apt/sources.list.d/kubernetes.list sudo chmod 644
/etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

# sudo apt install -y kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1 kubectl=1.31.0-1.1

sudo apt install -y kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1 kubectl=1.31.0-1.1
--allow-change-held-packages sudo apt-mark hold kubelet kubeadm kubectl

# Netzwerk einrichten

sudo apt update sudo apt install -y bridge-utils sudo modprobe br_netfilter
lsmod | grep br_netfilter sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1 sudo sysctl -w
net.ipv4.ip_forward=1

echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf sudo sysctl -p

echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf

# --------------------

# Auf k8smain01

# --------------------

# Cluster initialisieren

sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.31.0

# kubeadm join 10.0.3.47:6443 --token g9ygqr.x4dcykhqxfodhjnm \

# --discovery-token-ca-cert-hash sha256:c762ec5608715cc2b76b1688c17a68600131e07ec574fb5cbdffca0b79231bc5

# kubectl konfigurieren

mkdir -p
$HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id
-g) $HOME/.kube/config

kubectl create -f
https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/tigera-operator.yaml
wget
https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/custom-resources.yaml
-O /tmp/custom-resources.yaml kubectl create -f /tmp/custom-resources.yaml

# join command für worker generieren

kubeadm token create --print-join-command

# --------------------

# Auf k8sworker01

# --------------------

# dem cluster beitretten (mit sudo)

sudo kubeadm join 10.0.3.47:6443 --token umquqn.00hcz7sdkgu3y80g
--discovery-token-ca-cert-hash
sha256:c762ec5608715cc2b76b1688c17a68600131e07ec574fb5cbdffca0b79231bc5

We created a longer version with load balancing but we kept running into the
same error and we could not figure out how to fix it. You can find the whole
file on the GitHub Link above.

### [Example] Lorem Ipsum....

- Step: [Example] Initializing wrong parameter
- What: [Example] Container Runtime was not working
- Solved via: [Example] adaption of config

- Step: Installing the correct version of k8s
- What: we were not able to install the correct version of kubernets it kept
  saying it does not exist.
- Solved via: deleting the Switch machine and setting it up using, the same
  commands, worked on the second try.

- Step: Setting up load balancing with two main nodes
- What: As soon as we set up haproxy we kept getting 'localhost:8080' could not
  be accessed
- Solved via: We could not figure out how to fix this.

## Personal reflection

Now that you build up the cluster: What did you learn personally regarding
setting up a K8s-cluster. Get as technical as possible. Make this part for
yourself.

### [Example] Sebastian

- [Example] Workload-1: Generating a load balancer with quite hard....

### Gideon

- Container runtime: The installation of containerd as container runtime
  instead of Docker, I was able to build understanding for a runtime other than Docker
  build up.
- Kubeadm: I learned how to set up a Kubernetes container runtime by using Kubeadm in a
  fast and efficient way to set up a Kubernetes cluster.
- CNI: I have never set up a container network interface before and
  never thought about how they work before. For this
  task we used Calico and this made me realize the importance of network solutions for pod communication.


### Shane

- I realized the complexity of managing control plane and worker nodes: I found it challenging to configure the master (control plane) and worker nodes correctly, ensuring the proper ports and services were exposed.
- I learned that setting up Containerd to work with Kubernetes is an important part of creating a Kubernetes cluster. I found out that Containerd is the software that manages and runs containers, and it plays a key role in how Kubernetes works.
- I learned that Calico is a tool used to manage networking in Kubernetes clusters. It helps with communication between the different parts of the cluster, like the pods and nodes. I discovered that Calico creates a network where each pod can get its own unique IP address, allowing them to talk to each other. 

