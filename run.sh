#!/bin/sh

. ./utils.sh

CUBU_PATH=$(realpath .)

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

authorizeX11() {
  yellow "[I]: Creating X11 authentication file in $XAUTH"
  touch $XAUTH
  xauth nlist | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
}

docker_run() {
  # Authorize docker container to access the host Xorg
  authorizeX11

  run docker run -it \
      --rm \
      --name cudagl \
      --gpus all \
      --env="XAUTHORITY=$XAUTH" \
      --env="DISPLAY" \
      --volume="$XAUTH:$XAUTH:rw" \
      --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      --volume="/var/run/bumblebee.socket:/var/run/bumblebee.socket:rw" \
			--device /dev/dri/card0:/dev/dri/card0 \
      cudagl \
      "$@"
}

if test -z "$@"
then
	yellow "[I]: Running default command 'bash' on container" 
else
	yellow "[I]: Running command '$@' on docker container" 
fi

docker_run "$@" 
