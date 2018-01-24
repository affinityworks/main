FROM ubuntu:trusty
# 4 versions old, but it's what we use on prod ¯\_(ツ)_/¯

MAINTAINER austin <austin@affinity.works>
LABEL description="Base image for running affinity.works web app."
LABEL version="0.0.4"

# ------------------------------------------------------
# --- Configure System

# configure working dir, ports
RUN mkdir -p /affinity
WORKDIR /affinity
EXPOSE 3000

# install system dependencies
RUN apt-get update -qq
RUN apt-get install -y \
    apt-transport-https \
    build-essential \
    curl \
    git \
    libpq-dev \
    locales \
    nano

# set locale
RUN cp /usr/share/i18n/SUPPORTED /etc/locale.gen && \
    locale-gen && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# ------------------------------------------------------
# --- Install Javascript Dependencies

ARG node_version
ENV NODE_VERSION $node_version
ENV NVM_DIR "$HOME/.nvm"

# install node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ${HOME}/.bash_profile && \
    . ${HOME}/.bash_profile && \
    nvm install ${NODE_VERSION} && \
    nvm use ${NODE_VERSION}

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -q && \
    apt-get install -y yarn

# install javascript dependencies
RUN mkdir -p /affinity/client
COPY ./yarn.lock /affinity/package.json
COPY ./package.json /affinity/package.json
COPY ./client/yarn.lock /affinity/client/yarn.lock
COPY ./client/package.json /affinity/client/package.json
RUN bash -lc 'nvm use ${NODE_VERSION} && yarn install'

# ------------------------------------------------------
# --- Install Ruby Dependencies

ARG ruby_version
ENV RUBY_VERSION $ruby_version
ENV GEMSET_NAME "affinity"

# install ruby
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby && \
    echo '[ -s "$HOME/.rvm/scripts/rvm" ] && . /usr/local/rvm/scripts/rvm' >> $HOME/.bash_profile && \
    echo '[ -s "/etc/profile.d/rvm.sh" ] && . /etc/profile.d/rvm.sh' >> $HOME/.bash_profile && \
    . $HOME/.bash_profile
RUN bash -lc "rvm install ${RUBY_VERSION}"

# install rails dependencies
COPY ./Gemfile /affinity/Gemfile
COPY ./Gemfile.lock /affinity/Gemfile.lock
RUN bash -lc "rvm use ruby-${RUBY_VERSION} && \
              gem install --no-rdoc --no-ri foreman && \
              gem install --no-rdoc --no-ri bundler && \
              bundle install"

# ------------------------------------------------------
# --- Cleanup
RUN apt-get clean
