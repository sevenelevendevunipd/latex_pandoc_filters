FROM archlinux:latest

RUN set -x && \
  echo "[options]" >> /etc/pacman.conf && \
  echo "ParallelDownloads = 8" >> /etc/pacman.conf && \
  pacman -Sy --noconfirm python python-pip texlive-core texlive-latexextra plantuml wget librsvg \
      ttf-dejavu ditaa graphviz plantuml-ascii-math aspell aspell-it aspell-en && \
  wget -q -O /tmp/pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz && \
  sed -i 's/\$Master = "\$Master\/..\/..";/\$Master = "\$Master\/..\/..\/..";/' /usr/share/texmf-dist/scripts/texlive/tlmgr.pl && \
  /usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode init-usertree && \
  /usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode install \
      cm-super ly1 lm microtype ucharcat ulem unicode-math sourcecodepro sourcesanspro xecjk && \
  mkdir -p ~/.local/share/pandoc/filters && \
  wget -O ~/.local/share/pandoc/filters/spellcheck.lua https://raw.githubusercontent.com/pandoc/lua-filters/master/spellcheck/spellcheck.lua && \
  pacman -R --noconfirm wget && \
  tar xvf /tmp/pandoc.tar.gz -C /usr/bin --strip-components=2 pandoc-2.19.2/bin/pandoc && \
  pip install pandoc-glossary-filter pandoc-plantuml-filter-panflute && \
  rm -rf /var/lib/pacman/* /tmp/* /var/cache/pacman/* /root/.cache

VOLUME /pandoc
WORKDIR /pandoc

ENTRYPOINT ["pandoc"]
