FROM jenkins/inbound-agent:latest

LABEL maintainer="Juan Luis Rodriguez <juanluisrp@geocat.net>"

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV PYTHON_VERSION=3.13.3

# Install Python 3.9
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev 

 RUN curl https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz -o Python-${PYTHON_VERSION}.tar.xz \
 && tar -xf Python-${PYTHON_VERSION}.tar.xz \
 && mv Python-${PYTHON_VERSION} /usr/local/share/python3 \
 && cd /usr/local/share/python3 \
 && ./configure --enable-optimizations --enable-shared --with-ensurepip=install \
 && make -j 5 \
 && make altinstall \
 && ldconfig /usr/local/share/python3

 RUN ln -s "/usr/local/bin/python${PYTHON_VERSION%.*}" /usr/local/bin/python3 \
    && ln -s "/usr/local/bin/pip${PYTHON_VERSION%.*}" /usr/local/bin/pip3 

 RUN python3 --version
 RUN python3 -m ensurepip --version



RUN curl -o- https://raw.githubusercontent.com/transifex/cli/master/install.sh | bash \
    && mv tx /usr/local/bin/tx

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    apt-transport-https \
    gpg \
    git \
	gcc \
	gnupg \
        graphviz \
        imagemagick \
        make \
        #python3 \
        #python3-pip \
        #python3-venv \
        wget \
        software-properties-common \
        zlib1g \
        zlib1g-dev \
        apt-transport-https \
    && wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null \
    && echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
    && apt-get update \
        && apt-get install -y --no-install-recommends temurin-8-jdk \
        maven \
        ant \
        latexmk \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-fonts-recommended \
        tex-gyre\
    && rm -rf /var/lib/apt/lists/* 
RUN python3 -m pip install --no-cache-dir -U pip \
    && python3 -m pip install --no-cache-dir \
        Sphinx==6.2.1 \
        Pillow \
        JSTools \
        sphinx_bootstrap_theme \
        sphinx_rtd_theme \
        recommonmark \
        sphinx-intl \
        python-levenshtein \ 
        "jinja2<3.1"

RUN mkdir /workspace && \
  chown jenkins:jenkins /workspace


USER ${user}
RUN mkdir environments \
    && python3 -m venv environments/py3 \
    && . environments/py3/bin/activate \
    && python3 -m pip install --no-cache-dir \
        Sphinx==6.2.1 \
        Pillow \
        JSTools \
        sphinx_bootstrap_theme \
        sphinx_rtd_theme \
        recommonmark \
        sphinx-intl \
        python-levenshtein \ 
        "jinja2<3.1"


