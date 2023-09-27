FROM ubuntu:22.04

# Install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
        && apt-get upgrade -y --with-new-pkgs \
        && apt-get -y install --no-install-recommends nano unzip curl ca-certificates libexpat1 \
        libfile-spec-native-perl sqlite3 build-essential perl-doc libdbi-perl libdbd-sqlite3-perl \
    && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf /var/lib/apt/* \
    && cpan install common::sense Linux::Inotify2 \
        && rm -rf /root/.cpan/build \
        && rm -rf /root/.cpan/sources \
    && rm -rf /var/lib/cache/* /var/lib/log/* \
		    /var/tmp/* /usr/share/doc/ /usr/share/man/ /usr/share/locale/ \
		    /root/.cache /root/.local /root/.gnupg /root/.config /tmp/*

WORKDIR /work

COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh \
    && curl -O https://www.idrivedownloads.com/downloads/linux/download-for-linux/LinuxScripts/IDriveForLinux.zip && \
    unzip IDriveForLinux.zip && \
    rm IDriveForLinux.zip

WORKDIR /work/IDriveForLinux/scripts

RUN chmod a+x *.pl \
    && ln -s /work/IDriveForLinux/scripts/cron.pl /etc/idrivecron.pl \
    && mkdir -p /mnt/files \
    && touch /mnt/files/idrivecron \
    && chmod 755 /mnt/files/idrivecron \
    && ln -s /mnt/files/idrivecron /etc/init.d/idrivecron \
    && touch /mnt/files/idrivecrontab.json \
    && ln -s /mnt/files/idrivecrontab.json /etc/idrivecrontab.json \
    && mkdir -p /mnt/backup

COPY .serviceLocation .

# Run the command on container startup
ENTRYPOINT ["/work/entrypoint.sh"]
