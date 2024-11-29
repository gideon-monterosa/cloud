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
