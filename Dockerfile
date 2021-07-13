FROM jenkins/inbound-agent:latest

LABEL maintainer="Juan Luis Rodriguez <juanluisrp@geocat.net>"

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        graphviz \
        imagemagick \
        make \
        python3 \
        python3-pip \
        python3-venv \
        wget \
        software-properties-common \
    && wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    &&  add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt-get update \
        && apt-get install -y --no-install-recommends adoptopenjdk-8-hotspot \
        maven \
        ant \
        latexmk \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-fonts-recommended \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m pip install --no-cache-dir -U pip \
    && python3 -m pip install --no-cache-dir \
        Sphinx==3.5.4 \
        Pillow \
        JSTools \
        sphinx_bootstrap_theme \
        sphinx_rtd_theme \
        recommonmark \
        sphinx-intl \
        transifex-client \
        python-levenshtein
USER ${user}
RUN mkdir environments \
    && python3 -m venv environments/py3


