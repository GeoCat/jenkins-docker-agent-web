FROM jenkins/inbound-agent:latest

LABEL maintainer="Juan Luis Rodriguez <juanluisrp@geocat.net>"

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PIP_BREAK_SYSTEM_PACKAGES 1

# Install Python 3.9
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev 

 RUN curl https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tar.xz -o Python-3.9.18.tar.xz \
 && tar -xf Python-3.9.18.tar.xz \
 && mv Python-3.9.18 /usr/local/share/python3.9 \
 && cd /usr/local/share/python3.9 \
 && ./configure --enable-optimizations --enable-shared \
 && make -j 5 \
 && make altinstall \
 && ldconfig /usr/local/share/python3.9

 RUN python3.9 --version



RUN curl -o- https://raw.githubusercontent.com/transifex/cli/master/install.sh | bash \
    && mv tx /usr/local/bin/tx

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
	gcc \
	gnupg \
        graphviz \
        imagemagick \
        make \
        #python3 \
	    #python3-dev \
        #python3-pip \
        #python3-venv \
        wget \
        software-properties-common \
        zlib1g \
        zlib1g-dev \
        apt-transport-https \
    && wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /usr/share/keyrings/adoptium.asc \
    && echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
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
RUN python3.9 -m pip install --no-cache-dir -U pip \
    && python3.9 -m pip install --no-cache-dir \
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
    && python3.9 -m venv environments/py3 \
    && . environments/py3/bin/activate \
    && python3.9 -m pip install --no-cache-dir \
        Sphinx==6.2.1 \
        Pillow \
        JSTools \
        sphinx_bootstrap_theme \
        sphinx_rtd_theme \
        recommonmark \
        sphinx-intl \
        python-levenshtein \ 
        "jinja2<3.1"


