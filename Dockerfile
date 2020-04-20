FROM python:3.8.2-slim-buster

RUN set -ex \
    # Official Mopidy install for Debian/Ubuntu along with some extensions
    # (see https://docs.mopidy.com/en/latest/installation/debian/ )
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        gnupg2 \
 && wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add - \
 && wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mopidy \
        pkg-config \
        libcairo2-dev \
        gcc \
        libspotify-dev \
        python3-dev \
        libgirepository1.0-dev
 RUN pip install \
        Mopidy-Iris \
        Mopidy-Party \
        Mopidy-Spotify \
        Mopidy-YouTube \
        Mopidy-MPD \
        Mopidy-Jellyfin \
        pyopenssl \
        pyspotify \
        youtube-dl \
        gobject \
        PyGObject
RUN mkdir -p /root/.config/ \
 && ln -s /mopidy/ /root/.config/
    # Clean-up
RUN apt-get purge --auto-remove -y \
        wget \
        gnupg2 \
        gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

# Default configuration.
COPY mopidy.conf /mopidy/mopidy.conf
COPY mopidy.sh /usr/local/bin/mopidy.sh

# Allows any user to run mopidy, but runs by default as a randomly generated UID/GID.
# ENV HOME=/var/lib/mopidy
# RUN set -ex \
#  && usermod -G audio,sudo mopidy \
#  && chown mopidy:audio -R $HOME /usr/local/bin/mopidy.sh \
#  && chmod go+rwx -R $HOME /usr/local/bin/mopidy.sh

RUN chmod +x /usr/local/bin/mopidy.sh
# Runs as mopidy user by default.
# USER mopidy

VOLUME ["/var/lib/mopidy/local", "/var/lib/mopidy/media"]

EXPOSE 6600 6680
ENTRYPOINT ["/usr/local/bin/mopidy.sh"]
