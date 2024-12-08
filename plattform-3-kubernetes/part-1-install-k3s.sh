# k3s auf dem k3snode01 installieren (master)
sudo apt update && sudo apt upgrade -y

curl -sfL https://get.k3s.io | sh -s - server

# validate the installation
sudo systemctl status k3s
sudo k3s kubectl get nodes

# kopiere den token
sudo cat /var/lib/rancher/k3s/server/node-token

# k3s auf dem k3snode02 installieren (agent)
sudo apt update && sudo apt upgrade -y

curl -sfL https://get.k3s.io | K3S_URL=https://86.119.44.24:6443 K3S_TOKEN=TOKEN sh - # TOKEN durch den token ersetzen

# validate the installation
sudo systemctl status k3s-agent

# validate on the master
sudo k3s kubectl get nodes

# Tain auf dem master einrichten
sudo k3s kubectl taint node k3snode01 k3s-controlplane=true:NoSchedule
sudo k3s kubectl get nodes -o wide
sudo k3s kubectl describe node k3snode01 | grep Taints

# example workload ausführen
sudo k3s kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4
sudo k3s kubectl get deployments
sudo k3s kubectl get pods -o wide

# Reschedule der workload
sudo k3s kubectl get pods
sudo k3s kubectl delete pod pod-name # pod-name durch den pod name ersetzen
sudo k3s kubectl get pods -o wide

