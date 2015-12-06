DOCKER_MACHINE='default'
DOCKER_IMAGE='laos-firmware-builder'
DOCKER_CONTAINER='laos-firmware-builder'
BIN_DIR="./bin"
FIRMWARE_DIR="$PWD/Firmware"
SHARED_BIN="$PWD/bin:/home/bin"
SHARED_FIRMWARE="$PWD/Firmware:/home/Firmware"
GCC_ARM_PATH='/gcc-arm/gcc-arm-none-eabi-4_9-2015q3/bin/'

###############################################
function clone() {
  if [ ! -d "$FIRMWARE_DIR" ]; then 
  	echo 'Cloning Firmware'
  	git clone --recursive git@github.com:LaosLaser/Firmware.git
  fi
}

###############################################
function checkdocker() {
  echo 'Checking Docker'
  # start with basic docker check
  docker info > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo '[ok] Docker is available'
  else
    echo '[note] Docker not (yet) available'
    # checking Docker host availablility
    docker-machine inspect $DOCKER_MACHINE > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo '[note] Docker machine found, starting machine'
      docker-machine start $DOCKER_MACHINE
      echo '[note] Exporting Docker host environment variables'
      eval "$(docker-machine env $DOCKER_MACHINE)"
    else
      echo '[error] Can not start Docker, please install Docker. See: https://docs.docker.com/'
      exit 1
    fi
  fi
}

###############################################
function buildimage() {
  docker build -t $DOCKER_IMAGE docker-image
}

###############################################
function setup() {
  clone
  checkdocker
  buildimage 
}

###############################################
function build() {
  checkdocker
  
  mkdir -p $BIN_DIR
  
  # clear bin
  rm -rf $BIN_DIR/*
  echo "[ok] emptied $BIN_DIR"
  
  echo '[note] execute build.sh inside docker container'
  docker run --rm -v $SHARED_BIN -v $SHARED_FIRMWARE --name=$DOCKER_CONTAINER $DOCKER_IMAGE

  # check if succeeded
  NUM_BIN_FILES=`ls "$BIN_DIR" | wc -l`
  if [ $NUM_BIN_FILES -gt 0 ]; then
      echo "[ok] new built files are copied succesfully"
  else
      echo "[error] $BIN_DIR is empty"
      exit 1
  fi

  echo "[ok] done."
}

###############################################
function clean() {
  docker rm $DOCKER_CONTAINER
  docker rmi $DOCKER_IMAGE
  rm -r -f $BIN_DIR
  rm -r -f $FIRMWARE_DIR
}

###############################################
function interactive() {
  docker run --rm -t -i -v $SHARED_BIN -v $SHARED_FIRMWARE --name=$DOCKER_CONTAINER $DOCKER_IMAGE bash
}

###############################################
function update() {
  cd $FIRMWARE_DIR
  git pull
  cd -
}

###############################################
function help() {
  echo 'Usage: ./make.sh {COMMAND}'
  echo ''
  echo 'Commands:'
  echo '   setup                                        clone Firmware, create docker image'
  echo '   update                                       update Firmware'
  echo '   build                                        build laos laser binary (using docker container)'
  echo '   clean                                        remove docker image, docker container, binaries and Firmware'
  echo '   interactive                                  run interactive docker container'
  echo '   help                                         show this help'
  echo ''
}

###############################################
case "$1" in
setup) setup ;;
update) update ;;
build) build ;;
clean) clean ;;
interactive) interactive ;;
*) help ;;
esac
