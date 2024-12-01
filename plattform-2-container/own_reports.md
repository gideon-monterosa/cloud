# Handling Container Workload

During the implementation, Shane and I documented each step thoroughly. For this, we used the following GitHub repository.

[Giide0n/cloud](https://github.com/Giide0n/cloud)

We did 90% of the work through pair programming.

## Building up the platform together

On which steps above did you have technical problems? What was the problem? How did you solve it? Make subparagraphs for each point. 
Make this summary together in your group.

### [Example] Lorem Ipsum....
* Step: [Example] Initializing wrong parameter
* What: [Example] Swarm was purple
* Solved via: [Example] repainting the swam


### Adding the nodes to the docker swarm
* Step: [Example] Using wrong join Key to add nodes as Manager/Worker
* What: [Example] Both the worker nodes were added as Managers
* Solved via: [Example] At first we didn't know the cause. we thought it had something to do with a default setting. After some research we noticed that there are separate invitation-codes for workers and managers alike. We also came across the convenient function of demoting a node to worker. We tried both methods (demoting and worker invite) to see if the results would be the same and they were.

## Personal reflection

Now that you used Proxmox and Containers: Reflect personally (each person for him/herself), when would you choose containers and when would you use VMs.
Each person should give at least 3 examples with workloads and should argue about the decision. Use the technical differences of both platforms for your argumentation. Become as technical as possible. 

### [Example] Sebastian

* [Example] Workload-1: Generating load in a regular oven; more suitable for Proxmox because the type 3 hypervisor....

### Gideon
* ex1
* ex2
* ex3

### Shane
* Web Services (Containers): Containers are perfect for lightweight, scalable applications like web services. They start quickly and use fewer resources, making them ideal for fast deployments and scaling.
* Legacy Applications (VMs): VMs provide strong isolation and can run different operating systems. This makes them perfect for legacy applications that require a specific OS or need complete separation from the host system.
* Resource-Intensive Applications (VMs): VMs allocate dedicated resources (CPU, memory), making them better for applications that need guaranteed performance like databases or data analytics platforms.




