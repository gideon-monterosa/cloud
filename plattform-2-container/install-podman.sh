# install podman
sudo apt update
sudo apt install -y podman
podman --version

# pull the nginx image and confirm it is corretly downloaded
sudo podman pull docker.io/library/nginx:latest
sudo podman images

# run the image and confirm its running
sudo podman run -d --name nginx -p 8624:80 docker.io/library/nginx:latest
sudo podman ps




sudo apt-get -y install podman

sudo podman pull docker.io/library/nginx

sudo podman run --name nginx-web -d -p 8624:80 nginx
sudo podman generate systemd --name nginx-web --files --new
sudo cp container-nginx-web.service /etc/systemd/system/
sudo systemctl enable container-nginx-web.service
sudo systemctl start container-nginx-web.service
sudo podman generate systemd --name nginx-web --files --new --restart-policy=always
