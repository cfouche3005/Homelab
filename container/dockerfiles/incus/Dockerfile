FROM --platform=$TARGETARCH debian:bookworm-slim

ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH}
ARG VERSION=stable
ENV VERSION=${VERSION}

# We make a fake systemctl so that incus doesn't error out without systemd
RUN echo "#!/bin/bash" > /sbin/systemctl && \
    echo "exit 0" >> /sbin/systemctl && \
    chmod +x /sbin/systemctl

#Add contrib sources
COPY debian.sources /etc/apt/sources.list.d/debian.sources

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y curl ca-certificates

#Add Zabbly key
RUN curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc

#Add Zabbly sources
COPY ${TARGETARCH}/${VERSION}/zabbly.sources /etc/apt/sources.list.d/zabbly.sources

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    nftables \
    ebtables \
    arptables \
    iproute2 \
    thin-provisioning-tools \
    openvswitch-switch \
    btrfs-progs \
    lvm2 \
    udev \
    iptables \
    kmod \
    ovn-host \
    ovn-central \
    fuse \
    zfsutils-linux \
    && apt autoremove -y \
    && apt-get clean

# Install incus
RUN apt-get update && apt-get install --no-install-recommends -y \
    incus \
    incus-ui-canonical \
    && apt autoremove -y \
    && apt-get clean

# Add the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

CMD [ "/entrypoint.sh" ]