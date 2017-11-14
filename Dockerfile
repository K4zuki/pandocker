FROM ubuntu:16.04

ENV PLANTUML_VERSION 1.2017.18
ENV PLANTUML_DOWNLOAD_URL https://sourceforge.net/projects/plantuml/files/plantuml.$PLANTUML_VERSION.jar/download

ENV PANDOC_VERSION 2.0.1.1
ENV PANDOC_DOWNLOAD_URL https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-1-amd64.deb
ENV PANDOC_ROOT /usr/local/pandoc

RUN echo "deb http://ftp.jaist.ac.jp/pub/Linux/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://ftp.jaist.ac.jp/pub/Linux/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://ftp.jaist.ac.jp/pub/Linux/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get -y update && \

    apt-get -y install wget curl unzip && \
    apt-get -y --no-install-recommends install librsvg2-bin gpp && \

    apt-get -y --no-install-recommends install graphviz plantuml && \
    curl -fsSL "$PLANTUML_DOWNLOAD_URL" -o /usr/local/plantuml.jar && \
    echo "#!/bin/bash" > /usr/local/bin/plantuml && \
    echo "java -jar /usr/local/plantuml.jar \$@" >> /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml && \

    apt-get -y --no-install-recommends install python3-pip python3-setuptools && \
    pip3 install pyyaml pillow \
      pantable csv2table \
      six pandoc-imagine \
      svgutils && \

    # apt-get -y --no-install-recommends install cabal-install && \
    wget -c $PANDOC_DOWNLOAD_URL && \
    dpkg -i pandoc-$PANDOC_VERSION-1-amd64.deb && \
    wget -c https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.0.0-beta3/linux-ghc8-pandoc-2-0.tar.gz && \
      tar zxf linux-ghc8-pandoc-2-0.tar.gz && \
      mv pandoc-crossref /usr/local/bin/ && \

    apt-get -y install nodejs-legacy npm && \
    npm install -g phantomjs-prebuilt wavedrom-cli \
      fs-extra yargs onml bit-field && \

    apt-get -y install --no-install-recommends texlive-xetex xzdec texlive-lang-japanese && \
    mkdir -p /usr/share/texlive/texmf-dist/tex/latex/BXptool/ && \
      wget -c https://github.com/zr-tex8r/BXptool/archive/v0.4.zip && \
      unzip -e v0.4.zip && ls && \
      cp BXptool-0.4/bx*.sty BXptool-0.4/bx*.def /usr/share/texlive/texmf-dist/tex/latex/BXptool/ && \
    mktexlsr && \
    wget -c https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip && \
      unzip -e 1.050R-it.zip && cp source-code-pro-2.030R-ro-1.050R-it/TTF/SourceCodePro-*.ttf /usr/local/share/fonts/ && \
    wget -c https://github.com/adobe-fonts/source-sans-pro/archive/2.020R-ro/1.075R-it.zip && \
      unzip -e 1.075R-it.zip && cp source-sans-pro-2.020R-ro-1.075R-it/TTF/SourceSansPro-*.ttf /usr/local/share/fonts/ && \
    wget -c https://github.com/mzyy94/RictyDiminished-for-Powerline/archive/3.2.4-powerline-early-2016.zip && \
      unzip -e 3.2.4-powerline-early-2016.zip && \
      cp RictyDiminished-for-Powerline-3.2.4-powerline-early-2016/RictyDiminished-*.ttf /usr/local/share/fonts/ && \
    which gpp ; \
    which rsvg-convert ; \
    which python3 ; \
    which pandoc ; \
    which pandoc-crossref ; \
    which xelatex ; \
    which csv2table ; \
    which pantable ; \
    which panflute ; \
    which pandoc-imagine ; \
    which bitfield ; \
    which wavedrom ; \
    which plantuml ; \

    addgroup --gid 82 pandocker && adduser --uid 82 --disabled-password --system --group pandocker && \
    cd /home/pandocker && \
    wget -c https://github.com/K4zuki/pandoc_misc/archive/techbookfest-3.zip && \

    apt-get -y remove *-doc curl wget python3-pip cabal-install ghc unzip && \
      rm /pandoc-$PANDOC_VERSION-1-amd64.deb && \
      rm /linux*.gz && \
      apt-get -y clean && apt -y autoremove

USER pandocker

RUN whoami && cd && \
    ls -l && \
    unzip -e techbookfest-3.zip && mv pandoc_misc-techbookfest-3 pandoc_misc
# RUN git clone https://github.com/K4zuki/pandoc_misc.git

# RUN tlmgr option repository ftp://tug.org/historic/systems/texlive/2015/tlnet-final && \
#     tlmgr install oberdiek && \
#     tlmgr init-usertree

WORKDIR /home/pandocker

VOLUME ["/home/pandocker"]

CMD ["bash"]