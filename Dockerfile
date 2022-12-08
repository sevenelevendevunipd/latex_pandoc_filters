FROM archlinux:latest

RUN set -x && \
  echo "[options]" >> /etc/pacman.conf && \
  echo "ParallelDownloads = 8" >> /etc/pacman.conf && \
  pacman -Sy --noconfirm python python-pip texlive-core texlive-latexextra plantuml wget librsvg \
      ttf-dejavu ditaa graphviz plantuml-ascii-math aspell aspell-it aspell-en unzip && \
  wget -q -O /tmp/pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz && \
  wget -q -O /tmp/pandoc-plot.zip https://github.com/LaurentRDC/pandoc-plot/releases/download/1.5.5/pandoc-plot-Linux-x86_64-static.zip && \
  sed -i 's/\$Master = "\$Master\/..\/..";/\$Master = "\$Master\/..\/..\/..";/' /usr/share/texmf-dist/scripts/texlive/tlmgr.pl && \
  /usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode init-usertree && \
  /usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode install \
      cm-super ly1 lm microtype ucharcat ulem unicode-math sourcecodepro sourcesanspro xecjk && \
  mkdir -p ~/.local/share/pandoc/filters && \
  wget -O ~/.local/share/pandoc/filters/spellcheck.lua https://raw.githubusercontent.com/pandoc/lua-filters/master/spellcheck/spellcheck.lua && \
  tar xvf /tmp/pandoc.tar.gz -C /usr/bin --strip-components=2 pandoc-2.19.2/bin/pandoc && \
  unzip /tmp/pandoc-plot.zip -d /usr/bin && \
  chmod +x /usr/bin/pandoc-plot && \
  pip install pandoc-glossary-filter pandoc-plantuml-filter-panflute plotly kaleido && \
  pacman -R --noconfirm wget unzip && \
  rm -rf /var/lib/pacman/* /tmp/* /var/cache/pacman/* /root/.cache

VOLUME /pandoc
WORKDIR /pandoc

ENTRYPOINT ["pandoc"]
