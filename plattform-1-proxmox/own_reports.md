# Creating a proxmox cluster

## Describe all single steps (commands) installing the cluster.

During the implementation, Shane and I documented each step thoroughly. For this, we used the following GitHub repository.

[Giide0n/cloud](https://github.com/Giide0n/cloud)

We did 90% of the work pair programming.

## On which steps above did you have technical problems? What was the problem? How did you solved it? Make subparagraphs for each point (each person for himself/herself).

### [Example] Sebastian

#### [Example] Creating wrong network configuration

* Step: [Example] Initializing a proxmox node on one node
* What: [Example] Network was created in a duplicated way at starting proxmox on one node. The problem originated most probably from proxmox itself. 
* Solved via: [Example] I created a root pass for keeping access via Web Gui and removed the wrong network configuration.

### Gideon

#### Network Configuration: Public IPs instead of ten'ers

* Step: Setting up the network bridges between nodes
* What: The network bridges did not work because I used the public IPs in the configuration.
* Solved via: By replacing the public IPs with the ten'ers and rebooting the
problem was fixed.

#### Network Configuration: Booting the Debian VM

* Step: After creating the Debian VM and booting.
* What: After the instalation process the VM restarts but it couldnt start again.
* Solved via: When creating the VM I didnt declare the storage type and the
VM couldt write to the disk. After deleting and re-installing it with the correct
storage type it worked.

## Name 3 points you learned personally from this tutorial (each person for himself/herself)?

### [Example] Sebastian

* [Example] I learned that setting up cloud computing needs extensive knowledge regarding operating systems and linux.
* [Example] The host-files between each other are hard to maintain.
* [Example] The packages on debian are partiall out of date.

### Gideon

* Ive never worked with proxmox before. So I learned a lot about how clusters work
and how they can be set up.
* Setting up network bridges between the nodes and the entire network configuration
took several attempts before I was able to create a working configuration.
* I learned how you can set up the enviroment in a way that makes live migrations
possible and that its important if you are using local or shared storage.
