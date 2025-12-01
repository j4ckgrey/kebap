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
echo "Pushing images..."
for ARCH in amd64 arm64 armv7; do
  docker tag kebap:alpha-$ARCH $USERNAME/kebap:$VERSION-$ARCH
  docker push $USERNAME/kebap:$VERSION-$ARCH
done
echo "Creating Manifest..."
docker manifest create $USERNAME/kebap:$VERSION \
    $USERNAME/kebap:$VERSION-amd64 \
    $USERNAME/kebap:$VERSION-arm64 \
    $USERNAME/kebap:$VERSION-armv7
docker manifest push $USERNAME/kebap:$VERSION
echo "Done! Published $USERNAME/kebap:$VERSION"
