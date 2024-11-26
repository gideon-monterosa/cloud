# install docker on all nodes
sudo apt update
sudo apt install -y docker.io

# initialize the swarm on the manager
sudo docker swarm init --advertise-addr 86.119.29.159
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
scp debian@86.119.29.159:/home/debian/monitoringstack/docker-compose.yml ./ &&
scp debian@86.119.29.159:/home/debian/monitoringstack/prometheus/prometheus.yml ./

# remove the old networks if they exist
sudo docker network rm monitoring_back-tier monitoring_front-tier

# deploy the stack
sudo docker stack deploy -c docker-compose.yml monitoring

# verify the stack is running
sudo docker service ls
