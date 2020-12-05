# List commands
help:
  @just --list


# Build docker image
build:
  docker build --build-arg BUILD_DATE=$(date '+%FT%T%:z') -t jarppe/netspect:latest .
