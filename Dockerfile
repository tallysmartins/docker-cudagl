# Documentation links

# Nvidia-docker-tools repository with install instructions
# https://github.com/NVIDIA/nvidia-docker

# Blog post on how to expose x-server to docker, allowing OpenGL applications
# https://medium.com/@benjamin.botto/opengl-and-cuda-applications-in-docker-af0eece000f1

FROM nvidia/cudagl:10.1-base-ubuntu18.04 

# Disable interactive mode for installed packages
ENV DEBIAN_FRONTEND noninteractive
# This seems to be a workaround in a bug in glvnd library
ENV __GLVND_DISALLOW_PATCHING 1


RUN apt-get update -q && \
  apt-get install -y -qq  \
  mesa-utils primus

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

CMD ["bash"]
