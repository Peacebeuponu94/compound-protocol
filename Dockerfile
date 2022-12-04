FROM mhart/alpine-node:13.8.0@sha256:9cd8663d7ae46ef979b92b07b049b26d18603ae0b2a5d5774a97b497874cdd6d

RUN apk update && apk add --no-cache --virtual build-dependencies git python g++ make
RUN wget https://github.com/ethereum/solidity/releases/download/v0.8.10/solc-static-linux -O /bin/solc && chmod +x /bin/solc

RUN mkdir -p /compound-protocol
WORKDIR /compound-protocol

# First add deps
ADD ./package.json /compound-protocol
ADD ./yarn.lock /compound-protocol
RUN yarn install --lock-file

# Then rest of code and build
ADD . /compound-protocol

ENV SADDLE_SHELL=/bin/sh
ENV SADDLE_CONTRACTS="contracts/*.sol contracts/**/*.sol"
RUN npx saddle compile

RUN apk del build-dependencies
RUN yarn cache clean

CMD while :; do sleep 2073600; done
