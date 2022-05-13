# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less man wget tar git gzip unzip make cmake software-properties-common curl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ocaml omake flex bison
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++

ADD . /repo
WORKDIR /repo
RUN omake all
WORKDIR /repo/source
RUN touch test.sig
