#!/bin/bash
IMAGE_NAME="debianapachephp7"
TAG_VERSION="1.0"
docker build -t $IMAGE_NAME:$TAG_VERSION .