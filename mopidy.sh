#!/bin/bash

# Replace env var values in config
if [ -n "$SPOTIFY_USERNAME" ]; then
    sed -i "/\[spotify\]/,/\[.*\]/ s/username.*/username = ${SPOTIFY_USERNAME}/" /mopidy/mopidy.conf
fi
if [ -n "$SPOTIFY_PASSWORD" ]; then
    sed -i "/\[spotify\]/,/\[.*\]/ s/password.*/password = ${SPOTIFY_PASSWORD}/" /mopidy/mopidy.conf
fi
if [ -n "$SPOTIFY_CLIENT_ID" ]; then
    sed -i "/\[spotify\]/,/\[.*\]/ s/client_id.*/client_id = ${SPOTIFY_CLIENT_ID}/" /mopidy/mopidy.conf
fi
if [ -n "$SPOTIFY_CLIENT_SECRET" ]; then
    sed -i "/\[spotify\]/,/\[.*\]/ s/client_secret.*/client_secret = ${SPOTIFY_CLIENT_SECRET}/" /mopidy/mopidy.conf
fi

if [ -n "$JELLYFIN_USERNAME" ]; then
    sed -i "/\[jellyfin\]/,/\[.*\]/ s/username.*/username = ${JELLYFIN_USERNAME}/" /mopidy/mopidy.conf
fi
if [ -n "$JELLYFIN_PASSWORD" ]; then
    sed -i "/\[jellyfin\]/,/\[.*\]/ s/password.*/password = ${JELLYFIN_PASSWORD}/" /mopidy/mopidy.conf
fi
if [ -n "$JELLYFIN_HOSTNAME" ]; then
    sed -i "/\[jellyfin\]/,/\[.*\]/ s/hostname.*/hostname = ${JELLYFIN_HOSTNAME}/" /mopidy/mopidy.conf
fi
if [ -n "$JELLYFIN_LIBRARIES" ]; then
    sed -i "/\[jellyfin\]/,/\[.*\]/ s/libraries.*/libraries = ${JELLYFIN_LIBRARIES}/" /mopidy/mopidy.conf
fi

if [ -n "$MEDIA_DIR" ]; then
    sed -i "/\[local\]/,/\[.*\]/ s/media_dirs.*/media_dirs = ${MEDIA_DIR}/" /mopidy/mopidy.conf
fi

if [ ${APT_PACKAGES:+x} ]; then
    echo "-- INSTALLING APT PACKAGES $APT_PACKAGES --"
    apt-get install -y $APT_PACKAGES
fi
if  [ ${PIP_PACKAGES:+x} ]; then
    echo "-- INSTALLING PIP PACKAGES $PIP_PACKAGES --"
    pip install $PIP_PACKAGES
fi
if [ ${UPDATE:+x} ]; then
    echo "-- UPDATING ALL PACKAGES --"
    apt-get update
    apt-get upgrade -y
    pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U # Upgrade all pip packages
fi

exec mopidy