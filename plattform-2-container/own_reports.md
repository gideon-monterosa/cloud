# Handling Container Workload

During the implementation, Shane and I documented each step thoroughly. For
this, we used the following GitHub repository.

[Giide0n/cloud](https://github.com/Giide0n/cloud)

We did 90% of the work through pair programming.

## Building up the platform together

On which steps above did you have technical problems? What was the problem? How
did you solve it? Make subparagraphs for each point. Make this summary together
in your group.

### [Example] Lorem Ipsum....

- Step: [Example] Initializing wrong parameter
- What: [Example] Swarm was purple
- Solved via: [Example] repainting the swam

### Adding the nodes to the docker swarm

- Step: Using wrong join Key to add nodes as Manager/Worker
- What: Both the worker nodes were added as Managers
- Solved via: At first we didn't know the cause. we thought it had
  something to do with a default setting. After some research we noticed that
  there are separate invitation-codes for workers and managers alike. We also
  came across the convenient function of demoting a node to worker. We tried
  both methods (demoting and worker invite) to see if the results would be the
  same and they were.

### Installing the wrong version of docker

- Step: Installing docker on all nodes for docker swarm.
- What: We initially installed a old docker version which let to problems while
  trying to start the docker swarm.
- Solved via: Once we reallised we had an old version of docker it was an easy
  fix to upgrade to a newer version.

### Worker nodes didnt show in the Grafana dashboard

- Step: After running the docker swarm.
- What: Everything seemed to be working correctly but on the Grafana dashboard
  it didnt display information about the worker nodes.
- Solved via: We couldnt figure out what was wrong so we decided to set up all 3
  Nodes from scratch which fixed the problem.

## Personal reflection

Now that you used Proxmox and Containers: Reflect personally (each person for
him/herself), when would you choose containers and when would you use VMs. Each
person should give at least 3 examples with workloads and should argue about the
decision. Use the technical differences of both platforms for your
argumentation. Become as technical as possible.

### [Example] Sebastian

- [Example] Workload-1: Generating load in a regular oven; more suitable for
  Proxmox because the type 3 hypervisor....

### Gideon

In my Opinion developers should opt to use containers whenever possible and only
use VMs when there is a good reason you should not use a containerized approach
instead.

Some examples and arguments are:

Containers

- Microservices Architecture
  - Containers share the host OS kernel, making them significantly lighter and
    faster to deploy compared to VMs.
  - Containers encapsulate individual microservices, ensuring that each service
    runs in its own isolated environment.
- Continuous Integration / Continuous Deployment (CI/CD)
  - Containers provide consistent and reproducible environments for building,
    testing, and deploying applications.
- Stateless Applicaitons
  - Stateless applications do not retain any state between requests, making them
    ideal candidates for containerization. Containers can be started and stopped
    rapidly without concerns about data persistence.
  - Containers can be scaled horizontally to handle varying loads, allowing
    stateless applications to efficiently manage traffic spikes.

VMs

- Statefull Applications
  - Stateful applications, such as databases, require persistent storage that
    survives restarts and scaling operations. VMs can be configured with
    dedicated virtual disks and robust storage solutions
- Very Old Applications (fe. maybe hard to dockerize)
  - Legacy applications may depend on specific or outdated operating systems
    that are difficult to containerize. VMs allow these applications to run in
    their required environments without modification.
  - Some legacy software has intricate dependencies that are tightly coupled
    with the underlying OS. VMs can encapsulate these dependencies more
    effectively than containers.

### Shane

- Web Services (Containers): Containers are perfect for lightweight and scalable
  applications like web services. They start quickly and use fewer resources,
  making them ideal for fast deployments and scaling.
- Legacy Applications (VMs): VMs provide strong isolation and can run different
  operating systems. This makes them perfect for legacy applications that
  require a specific OS or need complete separation from the host system.
- Resource-Intensive Applications (VMs): VMs allocate dedicated resources (CPU,
  memory), making them better for applications that need guaranteed performance
  like databases or data analytics platforms.
