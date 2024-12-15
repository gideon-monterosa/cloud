# --------------------
# auf allen maschienen
# --------------------

# eval user hinzufügen

# add shanes ssh key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtMSm3Vi0ReI7Bv6vJCv6d4XjCobQ2MebIWk1rmKrP1aZInVoU+Z5NUVKn/Ze4Gqs0wjvbVBTVBaGBG+1z/DJRDmyqHqJ29lSvGfQqsXenTs5LqnXYHaNFUbqrxcWBGmYOcRjbWx+1tIFOs/LRFfM+74HJcCcVde6L6T3DLB6HsWrtnTDDXDoTJbxNVzjDcmft6bxvm3mS3L8ZHpmcgKVQLdlQLTfCXsXJzZyRQ37Bc1hc1c/t7KEphGgzpAr0BM+t/Rffcqq57gyrIfLseb1PIPTwJ1qjePcAhchvVV4YsbtFJJb9JMX6rqi+t9NnlXuCwXF8ulZaTaJ7UkijQqjw78m7jLz2eQaMQTiZJ/0rJGb/usmUpWsfoESyFuSWfMf0DzWuomare6oAYVaFJbT4zdW/u664nrN51M1fahc8zWCzmMxee4cvjNA8ehjDYB5TrbV55IW01LLo/HFDnRzxOiB4l8m9XLtkqn3GxEp/hyTT+9Cw2WXFpvQufHWXEz8= root@PimpJuice" >> ~/.ssh/authorized_keys

# update the machienes and install
sudo apt update && sudo apt upgrade -y
sudo apt install -y containerd vim

# erstelle die konfigurationsdatei für containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# bearbeite die konfiguration
sudo vi /etc/containerd/config.toml
# [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#   systemdcgroup = true

# restart
sudo systemctl restart containerd
sudo systemctl enable containerd

# kubernetes repository auf allen maschinen einrichten
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
# sudo apt install -y kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1 kubectl=1.31.0-1.1
sudo apt install -y kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1 kubectl=1.31.0-1.1 --allow-change-held-packages
sudo apt-mark hold kubelet kubeadm kubectl

# Netzwerk einrichten
sudo apt update
sudo apt install -y bridge-utils
sudo modprobe br_netfilter
lsmod | grep br_netfilter
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
sudo sysctl -w net.ipv4.ip_forward=1

echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf

# --------------------
# Auf k8smain01
# --------------------

# Cluster initialisieren
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.31.0
# kubeadm join 10.0.3.47:6443 --token g9ygqr.x4dcykhqxfodhjnm \
#         --discovery-token-ca-cert-hash sha256:c762ec5608715cc2b76b1688c17a68600131e07ec574fb5cbdffca0b79231bc5

# kubectl konfigurieren
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/custom-resources.yaml -O /tmp/custom-resources.yaml
kubectl create -f /tmp/custom-resources.yaml

# join command für worker generieren
kubeadm token create --print-join-command

# --------------------
# Auf k8sworker01
# --------------------

# dem cluster beitretten (mit sudo)
sudo kubeadm join 10.0.3.47:6443 --token umquqn.00hcz7sdkgu3y80g --discovery-token-ca-cert-hash sha256:c762ec5608715cc2b76b1688c17a68600131e07ec574fb5cbdffca0b79231bc5

# TODO:: AB HIER FUNKTIONIERTS NICHT MEHR
# --------------------
# Auf k8smain01
# --------------------
#
sudo kubeadm reset -f
sudo rm -rf /etc/cni /etc/kubernetes /var/lib/etcd
sudo rm -rf ~/.kube

sudo apt install -y haproxy
# sudo vi /etc/haproxy/haproxy.cfg
sudo bash -c 'cat <<EOF >> /etc/haproxy/haproxy.cfg

frontend kubernetes-frontend
    bind *:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    balance roundrobin
    server master1 10.0.3.47:6443 check
    # server master2 10.0.8.226:6443 check
EOF'

# TODO: STILL FAILES
sudo systemctl restart haproxy
sudo systemctl enable haproxy
# sudo systemctl stop haproxy
sudo systemctl status haproxy.service

sudo kubeadm init --control-plane-endpoint "10.0.3.47:6443" --upload-certs --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.31.0

mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/custom-resources.yaml -O /tmp/custom-resources.yaml
kubectl create -f /tmp/custom-resources.yaml

sudo kubeadm init phase upload-certs --upload-certs
sudo kubeadm token create --print-join-command

# --------------------
# Auf k8smain02
# --------------------

# Achtung der generierte Befehlt muss noch erweitert werden!
sudo kubeadm token create --print-join-command
kubeadm join 10.0.3.47:6443 --token chguvg.g62mvzasw1o3yvby --discovery-token-ca-cert-hash sha256:c762ec5608715cc2b76b1688c17a68600131e07ec574fb5cbdffca0b79231bc5 --control-plane --certificate-key 6f6d5288ed9b58f587c209f67cd2844919803467349106b6b7ca8f1f29f57733

# --------------------
# Validierungen
# --------------------

kubectl get pods -o wide
kubectl get pods -n kube-system
kubectl get pods -n calico-system
kubectl get nodes

# hello node erstellen und löschen
kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4
kubectl delete pod hello-node-db99f7bb9-cxwps
