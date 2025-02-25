FROM ubuntu:24.10

# copy sources
COPY . /home/jhipster/jhipster-dotnetcore

RUN \
  # configure the "jhipster" user
  groupadd jhipster && \
  useradd jhipster -s /bin/bash -m -g jhipster -G sudo && \
  echo 'jhipster:jhipster' |chpasswd && \
  mkdir /home/jhipster/app && \
  export DEBIAN_FRONTEND=noninteractive && \
  export TZ=Europe\Paris && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  apt-get update && \
  # install utilities
  apt-get install -y \
    wget \
    sudo \
    git && \
  # install node.js
  wget https://nodejs.org/dist/v22.13.0/node-v22.13.0-linux-x64.tar.gz -O /tmp/node.tar.gz && \
  tar -C /usr/local --strip-components 1 -xzf /tmp/node.tar.gz && \
  # upgrade npm
  npm install -g npm && \
  #install dotnet
  apt-get install -y dotnet-sdk-9.0 && \
  # cleanup
  apt-get clean && \
  rm -rf \
    /home/jhipster/.cache/ \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

RUN \
  # install the blueprint
  npm install -g /home/jhipster/jhipster-dotnetcore && \
  # fix jhipster user permissions
  chown -R jhipster:jhipster \
    /home/jhipster \
    /usr/local/lib/node_modules && \
  # cleanup
  rm -rf \
    /home/jhipster/.cache/ \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# expose the working directory
USER jhipster
ENV PATH $PATH:/usr/bin
WORKDIR "/home/jhipster/app"
VOLUME ["/home/jhipster/app"]
CMD ["jhipster-dotnetcore"]