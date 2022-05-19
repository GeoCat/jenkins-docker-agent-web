FROM jenkins/inbound-agent:latest

LABEL maintainer="Juan Luis Rodriguez <juanluisrp@geocat.net>"

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
	gcc \
	gnupg \
        graphviz \
        imagemagick \
        make \
        python3 \
	python3-dev \
        python3-pip \
        python3-venv \
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
    && rm -rf /var/lib/apt/lists/* 
RUN python3 -m pip install --no-cache-dir -U pip \
    && python3 -m pip install --no-cache-dir \
        Sphinx==3.5.4 \
        Pillow \
        JSTools \
        sphinx_bootstrap_theme \
        sphinx_rtd_theme \
        recommonmark \
        sphinx-intl \
        transifex-client \
        python-levenshtein \ 
        "jinja2<3.1"

RUN mkdir /workspace && \
  chown jenkins:jenkins /workspace


USER ${user}
RUN mkdir environments \
    && python3 -m venv environments/py3


