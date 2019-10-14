FROM alpine
MAINTAINER anekos

RUN apk update

RUN apk add alsa-lib alsa-lib-dev alsa-utils bash g++ make perl

RUN mkdir -p /tmp/build
WORKDIR /tmp/build
RUN wget -O v4.4.2.1.tar.gz https://github.com/julius-speech/julius/archive/v4.4.2.1.tar.gz
RUN tar xvzf v4.4.2.1.tar.gz
WORKDIR /tmp/build/julius-4.4.2.1

RUN ./configure --with-mictype=alsa
RUN make

RUN wget -O dictation-kit-v4.4.zip https://jaist.dl.osdn.jp/julius/66544/dictation-kit-v4.4.zip
RUN unzip dictation-kit-v4.4.zip

RUN apk add ruby

RUN mkdir -p /mnt/config

COPY init init
COPY listen listen
COPY debug debug
COPY mimi.rb mimi.rb


COPY mimi-base.jconf mimi-base.jconf


CMD ./listen




# RUN apk add gcompat zlib
# RUN cp gramtools/mkdfa/mkfa-1.44-flex/mkfa gramtools/mkdfa/mkfa
# RUN cp gramtools/dfa_minimize/dfa_minimize gramtools/mkdfa/dfa_minimize
# RUN gramtools/mkdfa/mkdfa.pl mimi

# RUN cp gramtools/mkdfa/mkfa-1.44-flex/mkfa gramtools/mkdfa/mkfa
# RUN cp gramtools/dfa_minimize/dfa_minimize gramtools/mkdfa/dfa_minimize
# WORKDIR /tmp/build/julius-4.4.2.1/mimi
# RUN ../gramtools/mkdfa/mkdfa.pl mimi

# RUN rm v4.4.2.1.tar.gz
# RUN rm dictation-kit-v4.4.zip
