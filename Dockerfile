FROM ubuntu:19.10
RUN apt-get update \
    && apt-get --assume-yes install -y \
    subversion \
    nano \
    git-core \
    git-svn \
    && apt  --assume-yes clean \
    && mkdir /work
COPY migrate.sh /work/migrate.sh
WORKDIR /work
CMD ["/bin/bash"]
ENTRYPOINT ["migrate.sh"]