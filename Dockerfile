FROM centos:7

MAINTAINER Paul Schoenfelder <paulschoenfelder@gmail.com>

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2019-03-18 \
    LANG=en_US.UTF-8 \
    HOME=/opt/app/ \
    # Set this so that CTRL+G works properly
    TERM=xterm \
    ERL_VERSION=21.2.4 \
    ELIXIR_VERSION=1.8.1

WORKDIR ${HOME}

# Install Erlang
RUN \
    mkdir -p /tmp && \
    yum install -y -q wget unzip make && \
    wget --no-verbose -P /tmp https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -q -y /tmp/epel-release-latest-7.noarch.rpm && \
    yum update -y -q && \
    yum upgrade -y -q --enablerepo=epel && \
    yum install -y -q wxGTK-devel unixODBC-devel && \
    wget --no-verbose -P /tmp/ "https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_${ERL_VERSION}-1~centos~7_amd64.rpm" && \
    rpm -Uvh "/tmp/esl-erlang_${ERL_VERSION}-1~centos~7_amd64.rpm" && \
    wget --no-verbose -P /tmp/ "https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip" && \
    unzip /tmp/Precompiled.zip -d /usr/local && \
    rm /tmp/Precompiled.zip && \
    mix local.rebar --force && \
    mix local.hex --force

CMD ["/bin/bash"]
