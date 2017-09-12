#!/usr/bin/env bash

usage() {
  echo "
usage: $0 <parameters>
  Required parameters:
    --version VERSION      repository version (e.g. 0.0.1)

    Optional parameters:
     --name NAME           repository name
     --package PACKAGE     Name of the debian package to create (default: NAME-VERSION.deb)
  "
  exit 1
}

if [ $# -lt 1 ];
then
    usage
fi

while [ $# -gt 0 ]; do
  OPT=$1
  case ${OPT} in
    --name)
      NAME=$2 ; shift 2
      ;;
    --version)
      VERSION=$2 ; shift 2
      ;;
    --package)
      PACKAGE=$2 ; shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

if [ -z "${VERSION}" ]; then
    echo Missing parameter: VERSION
    usage
fi

NAME="my-repo"
PACKAGE="my-repo-${VERSION}.deb"
DESCRIPTION="my-repo debian package"

if test -d /home/my-repo-temp; then
  rm -rf /home/my-repo-temp
fi

mkdir /home/my-repo-temp
cp -r ../Package2Debian /home/my-repo-temp

# --prefix=install dir
fpm --prefix=/home/app \
    -s dir \
    -C /home/straas/straas-config-deb \
    -t deb \
    -n ${NAME} \
    -v ${VERSION} \
    -p ${PACKAGE} \
    -a ${ARCH} \

rm -rf /home/my-repo-temp
