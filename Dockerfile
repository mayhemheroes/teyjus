FROM --platform=linux/amd64 ubuntu:24.04 AS builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential ocaml ocaml-dune flex bison

ADD . /repo
WORKDIR /repo
RUN dune build @install
WORKDIR /repo/source
RUN touch test.sig

RUN mkdir -p /deps
RUN ldd /repo/_build/install/default/bin/tjcc | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:24.04 AS package

COPY --from=builder /deps /deps
COPY --from=builder /repo/_build/install/default/bin/tjcc /repo/source/tjcc.opt
ENV LD_LIBRARY_PATH=/deps
