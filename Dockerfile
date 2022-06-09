FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential ocaml omake flex bison

ADD . /repo
WORKDIR /repo
RUN omake all
WORKDIR /repo/source
RUN touch test.sig

RUN mkdir -p /deps
RUN ldd /repo/source/tjcc.opt | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/source/tjcc.opt /repo/source/tjcc.opt
ENV LD_LIBRARY_PATH=/deps
