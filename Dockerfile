FROM jenkins/inbound-agent:latest

LABEL MAINTAINER="Juan Luis Rodriguez <juanluisrp@geocat.net>"

USER root
RUN apt-get update && apt-get install -y \
        git \
        graphviz \
        imagemagick \
        make \
        python3 \
        python3-pip \
        python3-venv \
        software-properties-common \ 
    && wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt-get update \
    && apt-get install -y adoptopenjdk-8-hotspot \
        maven \
        ant \
        latexmk \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-fonts-recommended \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U pip
RUN python3 -m pip install \
    Sphinx==3.0.1 \
    Pillow \
    JSTools \
    sphinx_bootstrap_theme \
    sphinx_rtd_theme \
    sphinx-intl \
    transifex-client
USER ${user}
RUN mkdir environments \
    && python3 -m venv environments/py3


