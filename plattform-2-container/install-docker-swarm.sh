# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install docker packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# initialize the swarm on the manager
sudo docker swarm init
# copy the swarm token
sudo docker swarm join-token worker

# Open the Ports 2377, 7946 and 4789 (Docker Swarm Security Group)
# join the swarm on the worker nodes
sudo docker swarm join --token SWMTKN-1-22exb5bz3j03nrfpnpbnnua7bhne0y2h1naf8a5ig8jdgvd9v9-8l2jrdyc2lwkgjejawmvkmj2r 86.119.29.159:2377

# check the swarm on the mng
sudo docker node ls

# install git and clone the monitoring stack on the mgr
sudo apt install git
git clone https://gitlab.fhnw.ch/cloud/cloud/monitoringstack.git
cd monitoringstack

# update the docker-compose.yml and prometheus.yml according to the files in this directory
# copy the files with
scp debian@86.119.29.159:/home/debian/monitoringstack/docker-compose.yml ./configs/ &&
scp debian@86.119.29.159:/home/debian/monitoringstack/prometheus/prometheus.yml ./configs/
# upload the files with
scp ./configs/docker-compose.yml debian@86.119.29.159:/home/debian/monitoringstack/ &&
scp ./configs/prometheus.yml debian@86.119.29.159:/home/debian/monitoringstack/prometheus/

# remove the old networks if they exist
sudo docker network rm monitoring_back-tier monitoring_front-tier

# deploy the stack
sudo docker stack deploy -c docker-compose.yml monitoring

# verify the stack is running
sudo docker service ls
