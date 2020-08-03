# Docker Nividia GL + CUDA 

Docker containers with nvidia drivers that allow CUDA and GL applications;

We assume  that:

- 1: you have NVIDIA drivers installed.
- 2: if you are on optimus system with bumblebee use the `bumblebee` branch of this repository.


First, make sure the drivers are working.  Install `mesa-utils` with `apt install mesa-utils`.
If mesa-utils is not available, try the `glmark2` package.
These are OpenGL benchmarking applications that display the rendering settings.

Now execute one of the commands below and make sure the output displays Nvidia information:

`$ optirun glxinfo | grep -i vendor` OR `$ optirun glmark2` 

```
# Command output must display NVIDIA information

server glx vendor string: NVIDIA Corporation
client glx vendor string: primus
OpenGL vendor string: NVIDIA Corporation
```

This shows that your driver package is well configured and you will be OK to run
applications within your GPU, otherwise you have to make this work before continuing.

### Installing docker

Below we describe the steps to run it. There are further details that you can read here in this docker [README.md](docker/RREADME.md).

__Step 1: Install docker__: Install a docker version >= 19. On Ubuntu 18.04 you can have it by installing the `docker.io` package.

`$ apt install docker.io`

Docker operates with sudo by default, but you can add your user do docker group to be able to run commands without sudo.

> Create the docker group. `$ sudo groupadd docker`
>
> Add your user to the docker group. `$ sudo usermod -aG docker $USER`
>
> Log out and log back in so that your group membership is re-evaluated.
>
> Verify that you can run docker commands without sudo, i.e.g. `$ docker ps`

__Step 2: Install nvidia docker toolkit__: To run docker with nvidia support we an additional package that allow using
gpu profiles when executing docker containers. 

You can refer to [the official reposiyory](https://github.com/NVIDIA/nvidia-docker),
but here follows the instructions for __Ubuntu 16.04/18.04/20.04, Debian Jessie/Stretch/Buster__ distros.

```
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

__Step 3: Build the docker image that matches your driver__: This step should be straightforward.
But you need to check if the driver that you installed matches the docker image from the [Dockerfile](Dockerfile).

The image set is the `nvidia/cudagl:10.1-base-ubuntu18.04`. If you have installed a driver version prior to `418.39`, you have to change it
as referred in the [nvidia docker hub](https://hub.docker.com/r/nvidia/cudagl). Otherwise, just continue.

According to their documentation the supported images and drivers are:

| Image Tag                 | Driver Version |
|---------------------------|----------------|
| 10.1-{base,runtime,devel} | >= 418.39      |
| 10.0-{base,runtime,devel} | >= 410.48      |
| 9.2-{base,runtime,devel}  | >= 396.26      |

 
After that, just run the build script. It will basically run the `docker build` command with a few arguments.
It might take a few minutes to complete.

`$ ./build`

__Step 4: Make sure your docker image can execute__: We provide a script to execute commands in the container you just built.
To verify that it is working, you can execute a simple command that checks the integration with the nvidia drivers. 

`$ optirun ./run.sh nvidia-smi`

Make sure it  displays your nvidia-card information.

```
Sun Aug  2 19:42:28 2020       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.100      Driver Version: 440.100      CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce 940MX       Off  | 00000000:01:00.0 Off |                  N/A |
| N/A   30C    P0    N/A /  N/A |      5MiB /  4046MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```

__Step 5: Make sure you can execute GL applications with nvidia__: Rendering
is a separate thing and we need to make sure the container uses the Nvidia GPU card
to render GL applications as well. You can check this with the same previous
`glxinfo` command, but now from inside the container, to see if Nvidia is the driver in use:
**For GL We need to use optirun from inside the  container as well.**

`
$ optirun ./run.sh optirun glxinfo | grep -i vendor
`

If the output contains NVIDIA information __CONGRATULATIONS__!!! 
# Support

## Successful installations

Below we list configurations where we correctly executed the project. Cuda version and GCC version only
applies to native installation, since its fixed on docker to Cuda 10.1 and GCC 7.0.

| OS           | GPU          | Driver Version | Optimus? | Docker image                           |
|--------------|--------------|----------------|----------|----------------------------------------|
| Ubuntu 18.04 | Nvidia 940mx | 440            | Yes      | nvidia/cudagl:10.1-base-ubuntu18.04, <br> nvidia/cudagl:10.1-devel-ubuntu18.04   |
