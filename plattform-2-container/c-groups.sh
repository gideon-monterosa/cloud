# attach to the container, install stress-ng and run some tests
sudo lxc-start -n cloud-test
sudo lxc-ls --fancy
sudo lxc-attach -n cloud-test

# Can be skipped if already done in a previous script
dnf install -y epel-release stress-ng

stress-ng --cpu 1 --cpu-load 100 --vm 1 --vm-bytes 520M --vm-method all --timeout 6m

# Set Limits (CPU, Memory) that are Persisted 
sudo vim /var/lib/lxc/cloud-test/config

# TODO: this configuration uses cGroup v2 confirm that that complies with the exercise

# Add the following two lines to the container specific configuration
# lxc.cgroup2.cpuset.cpus = 1
# lxc.cgroup2.memory.max = 512M

# Restart the container
sudo lxc-stop -n cloud-test
sudo lxc-start -n cloud-test

# Verify the configuration
sudo lxc-cgroup -n cloud-test cpuset.cpus
sudo lxc-cgroup -n cloud-test memory.max
