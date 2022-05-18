FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential ocaml omake flex bison

ADD . /repo
WORKDIR /repo
RUN omake all
WORKDIR /repo/source
RUN touch test.sig
