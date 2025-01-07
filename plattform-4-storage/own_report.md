# Building Ceph

## Building up the platform together

Describe all steps building the cluster with commands. On which steps above did
you have technical problems? What was the problem? How did you solved it? If you
proceed to Part 3, how did you implement the load balancing? Make subparagraphs
for each point. Make this summary together in your group.

we created the following script during the excercise, it involves all steps
taken.

sudo apt update sudo apt install -y cephadm

# install docker

sudo apt-get update sudo apt-get install ca-certificates curl sudo install -m
0755 -d /etc/apt/keyrings sudo curl -fsSL
https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc]
https://download.docker.com/linux/debian \
 $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin
docker-compose-plugin

# -----------------------

# Auf monitor1

# -----------------------

sudo cephadm bootstrap --mon-ip 10.0.1.77

# URL: https://monitor01.novalocal:8443/

# User: admin

# Password: fjfz39xhga

cat /etc/ceph/ceph.pub

# Key kopieren -> diesen müssen wir auf den osds als authorized_keys hinzufügen

# -----------------------

# Auf osd01, osd02, osd03

# -----------------------

# add the ceph public key

sudo su echo "ssh-rsa
AAAAB3NzaC1yc2EAAAADAQABAAABgQC+vmEdJ50pIIEZ1UjcVB8Idi2d8VSmKaVCdDlsuDncQIJojlblB58WNvPXzjD5VZwzYXJcTt9yjr9RrKC+QfvcyM6WKZQ8LhtMLI0KhWbOE7aa0jav9hXB+UOCCHIYq4t1kcNvUjdOo/VxRqrg7PLlgaXhT8NFp/oZH6BNUcqGc36YlyrUIm7DZLlLSZYNAtUHY4dLpn4jpkUFgVMXPpCMTyYH416wXJDjWK7OvzO01udqdk5pKago4p75UhNqQ8zMhyZAsFRyp485CvBgDVVNmYdJOhD2RayaZLrZJcVn51oVeMGwLDz1dtX4qF+4fQulsQzaWUiJfs9ZQ1TL4xEnc9xVfyO/iJXqIdpV0kpq9XdhvvAbYEN+FB/+u3cLQ4nvjL2GbImvbSIk5KDe43Aqc3KXx2u9ufqdqQk+89zJBh5XbXy5U6q2UBFYaffEsWrTQkJAL9E0VoYgf7VXdoOh0QFFa0VXvTiTCFNWb+1QOKUhHf4yVnBt+gC9Y0CrdtM=
ceph-72bc6258-cd20-11ef-8488-fa163eb2f581" > /root/.ssh/authorized_keys

# exit super user

# -----------------------

# Auf monitor1

# -----------------------

# add the osds to the cluster

sudo cephadm shell ceph orch host add osd01 10.0.1.226 ceph orch host add osd02
10.0.3.183 ceph orch host add osd03 10.0.4.50

# Check if everything worked (wait a few minutes first)

ceph orch ps ceph orch host ls ceph orch device ls

ceph orch apply osd --all-available-devices --dry-run ceph orch apply osd
--all-available-devices

# Check the osds

ceph osd tree ceph osd status ceph health ceph status

# Setting up Block Storage

ceph osd pool create 01-rbd-cloudfhnw rbd pool init 01-rbd-cloudfhnw ceph auth
get-or-create client.01-cloudfhnw-rbd mon 'profile rbd' osd 'profile rbd
pool=01-rbd-cloudfhnw' mgr 'profile rbd pool=01-rbd-cloudfhnw' rbd create --size
2048 01-rbd-cloudfhnw/01-cloudfhnw-cloud-image

# Check

ceph osd pool get 01-rbd-cloudfhnw all ceph auth get client.01-cloudfhnw-rbd rbd
info 01-rbd-cloudfhnw/01-cloudfhnw-cloud-image

# Setting up File Storage

ceph fs volume create cephfs-cloudfhnw ceph fs authorize cephfs-cloudfhnw
client.02-cloudfhnw-cephfs / rw

# Check

ceph fs status cephfs-cloudfhnw ceph auth get client.02-cloudfhnw-cephfs

# -----------------------

# Auf allen

# -----------------------

# enable ceph cli

sudo cephadm add-repo --release squid sudo cephadm install ceph-common

### Using the Ceph Cli properly

- Step: Setting up the cluster
- What: After installing ceph it took us way to long to realise that the ceph
  command is only available inside the cephadm cli.
- Solved via: quit beeing stupid :)

### Adding the osds to the cluster

- Step: Adding the osds to the cluster
- What: During our first try we forgot to add the public key of monitor01 to the
  osds.
- Solved via: In our second try we added the key to the authorized_keys file and
  it worked

## Personal reflection

Now that you build up the cluster: What did you learn personally regarding
setting up a Ceph-cluster. Get as technical as possible. Make this part for
yourself.

### Gideon

- Understanding the Architecture of Ceph: This plattform helped me to better
  understand the Architecture of Ceph, including monitors, object storage
  daemons (OSDs), managers and how they all interconnect

- Configuring block storage: Setting up block storage (RBD) by initializing RBD
  pools, managing the Ceph authentication and then generationg RBD images.
