# Cloud Computing

Repository für das Cloud Computing Modul an der FHNW.

## Plattform 1: Proxmox

### IPS

node01: 86.119.46.3

node02: 86.119.44.187

node03: 86.119.45.22

connect to the server with:

```sh
ssh debian@<ip>
```

### Proxmox Webinterfaces

username: root password: cloud1

[node01](https://86.119.46.3:8006/)

[node02](https://86.119.44.187:8006/)

[node03](https://86.119.45.22:8006/)

### How to setup

1. Settup the switch engine machines. **Dont forget to Open the Port 8006 for
   the Proxmox Webinterface to work** this means adding the Proxmox security
   group to the switch engine.
2. Complete the steps in `./plattform-1-proxmox/run-on-all-nodes.sh` for all
   three nodes.
3. Complete the steps in `./plattform-1-proxmox/run-on-node01.sh` on node01.
4. Complete the steps in `./plattform-1-proxmox/run-on-other-nodes.sh` on node02
   and node03.
5. Use './plattform-1-proxmox/install-debian-from-iso.sh' and
   './plattform-1-proxmox/install-arch-from-qcow2.sh' to install the VMs
6. Follow the instructions in './plattform-1-proxmox/migrate-to-other-nodes.sh'
   to clone, migrate the VMs and enable high availability.

### Usefull Commands

- `pvecm status`: Check disk configuration of the Node
- `qm config <vm-id>`: Check current configuration of an VM

## Plattform 2: Container

### IPS

container-lxc-host: 86.119.31.37

Monitoring Links:

- [86.119.31.37:8080](cAdvisor)
- [86.119.31.37:9090](Prometheus)
- [86.119.31.37:9100](Node-Exporter)
- [86.119.31.37:9113](Nginx-Exporter)
- [86.119.31.37:3000](Grafana)

docker-mgr-01: 86.119.30.172

docker-wrk-01: 86.119.30.110

docker-wrk-02: 86.119.30.210

Monitoring Links:

- [86.119.29.159:3000](Grafana)
- [86.119.29.159:9090](Prometheus)
