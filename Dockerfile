FROM archlinux:multilib-devel

# Install prerequisites
RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -Syu \
    wine \
    winetricks \
    wine-gecko \
    wine-mono \
    xorg-server-xvfb \
    samba \
    lib32-gnutls \
    gnutls \
    lib32-libxcomposite \
    libxcomposite \
    unzip \
    wget \
    curl

# Custom Environment Variables
ENV PUID=99 \
    PGID=100 \
    TZ=UTC \
    MULTITHREADING=false \
    PORT= \
    PUBLIC_PORT= \
    PUBLIC_IP= \
    SERVER_NAME= \
    SERVER_DESCRIPTION= \
    SERVER_PASSWORD= \
    ADMIN_PASSWORD= \
    UPDATE_ON_BOOT=true \
    WINETRICKS_ON_BOOT=true \
    RCON_ENABLED=true \
    BACKUP_ENABLED=true \
    OLD_BACKUP_DAYS=30 \
    DELETE_OLD_BACKUPS=false \
    COMMUNITY=

# Install Supercronic
# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.29/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=cd48d45c4b10f3f0bfdd3a57d054cd05ac96812b

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic



# Install Tini
ARG TINI_VERSION=0.19.0
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Install RCON
RUN wget https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz \
    && echo "8601c70dcab2f90cd842c127f700e398 rcon-0.10.3-amd64_linux.tar.gz" | md5sum -c - \
    && tar xfz rcon-0.10.3-amd64_linux.tar.gz \
    && chmod +x "rcon-0.10.3-amd64_linux/rcon" \
    && mv "rcon-0.10.3-amd64_linux/rcon" "/usr/local/bin/rcon" \
    && ln -s "/usr/local/bin/rcon" /usr/local/bin/rconcli \
    && rm -Rf rcon-0.10.3-amd64_linux rcon-0.10.3-amd64_linux.tar.gz

# Install Gosu
ADD https://github.com/tianon/gosu/releases/download/1.9/gosu-i386 /gosu
RUN chmod +x /gosu

# Setup a Wine prefix
ENV WINEPREFIX=/app/.wine
ENV WINEARCH=win64

# Change Winetricks cache directory
ENV XDG_CACHE_HOME=/app/.cache

# Configure locale for unicode
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
ENV LANG=en_US.UTF-8
RUN locale-gen

# Setup Environment
COPY scripts/* /
COPY crontab /crontab


EXPOSE 8211/udp
EXPOSE 25575
EXPOSE 27015
VOLUME /app
VOLUME /backup
ENV DISPLAY :99

# Setup User/Group
RUN groupadd --gid $PGID pal && \
    useradd --uid $PUID --gid $PGID -M pal


RUN chmod +x /*.sh


# Run the application
ENTRYPOINT ["/tini","/entrypoint.sh"]

