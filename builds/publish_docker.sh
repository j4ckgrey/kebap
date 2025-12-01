#!/bin/bash
set -e
echo "Kebap Docker Publisher"
read -p "Enter Docker Hub Username: " USERNAME
if [ -z "$USERNAME" ]; then echo "Username cannot be empty."; exit 1; fi
VERSION="alpha"
echo "Loading images..."
docker load -i kebap-docker-alpha-amd64.tar
docker load -i kebap-docker-alpha-arm64.tar
docker load -i kebap-docker-alpha-armv7.tar

echo "Pushing images to Docker Hub..."
for ARCH in amd64 arm64 armv7; do
  docker tag kebap:alpha-$ARCH $USERNAME/kebap:$VERSION-$ARCH
  docker push $USERNAME/kebap:$VERSION-$ARCH
done
echo "Creating Docker Hub Manifest..."
docker manifest create $USERNAME/kebap:$VERSION \
    $USERNAME/kebap:$VERSION-amd64 \
    $USERNAME/kebap:$VERSION-arm64 \
    $USERNAME/kebap:$VERSION-armv7
docker manifest push $USERNAME/kebap:$VERSION

echo "Pushing images to GHCR..."
GHCR_IMAGE="ghcr.io/$USERNAME/kebap"
for ARCH in amd64 arm64 armv7; do
  docker tag kebap:alpha-$ARCH $GHCR_IMAGE:$VERSION-$ARCH
  docker push $GHCR_IMAGE:$VERSION-$ARCH
done
echo "Creating GHCR Manifest..."
docker manifest create $GHCR_IMAGE:$VERSION \
    $GHCR_IMAGE:$VERSION-amd64 \
    $GHCR_IMAGE:$VERSION-arm64 \
    $GHCR_IMAGE:$VERSION-armv7
docker manifest push $GHCR_IMAGE:$VERSION

echo "Done! Published to Docker Hub and GHCR."
