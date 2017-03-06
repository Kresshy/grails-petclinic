#!/usr/bin/env bash

USAGE=$'
Usage: build.sh -[iub]
\t -i -image_name \t\t docker image name,
\t -u -upload_image \t\t upload docker image (default: false)
\t -b -build_version \t\t build version'

#Default value
UPLOAD_IMAGE="false"

while getopts ":i:u:b:" opts; do
   case ${opts} in
      i) IMAGE_NAME=${OPTARG}
      ;;
	  u) UPLOAD_IMAGE=${OPTARG}
      ;;
      b) BUILD_VERSION=${OPTARG}
      ;;
      h) HELP=${OPTARG}
          echo $USAGE >&2
      ;;
      \?) echo "Invalid option -$OPTARG.
                $USAGE" >&2
          exit 1
      ;;
   esac
done

if [ -z "$IMAGE_NAME" ]; then
    echo "$USAGE" >&2
    exit 1
fi

if [ -z "$BUILD_VERSION" ]; then
    echo "$USAGE" >&2
    exit 1
fi

errorHandler () {
    errcode=$?
    exit $errcode
}

trap  errorHandler ERR

echo "===== Building war file ====="

./grailsw war

echo "===== Building docker image ====="

TAG="${IMAGE_NAME}:${BUILD_VERSION}"

if [ "$UPLOAD_IMAGE" = "true" ]
  then
    UPLOAD_DOCKER_IMAGE=1
  else
    UPLOAD_DOCKER_IMAGE=0
fi

docker build -t $TAG .

if [ $UPLOAD_DOCKER_IMAGE -eq 1 ]; then
    echo "===== Uploading docker image ====="
    docker push $TAG
fi

echo "===== Removing local docker image ====="
docker rmi $TAG