FROM ubuntu:22.04

# Install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends nano unzip curl ca-certificates libexpat1 \
    libfile-spec-native-perl sqlite3 build-essential perl-doc libdbi-perl libdbd-sqlite3-perl \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
RUN cpan install common::sense Linux::Inotify2 \
    && rm -r /root/.cpan/build \
    && rm -r /root/.cpan/sources

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
