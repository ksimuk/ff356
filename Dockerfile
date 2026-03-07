# STAGE 1: Modern downloader (Solves the SSL/TLS 404/Unknown Protocol issue)
FROM alpine:latest AS downloader
RUN apk add --no-cache wget
RUN wget https://ftp.mozilla.org/pub/firefox/releases/3.5.6/linux-i686/en-US/firefox-3.5.6.tar.bz2 -O /tmp/firefox.tar.bz2

# STAGE 2: Legacy 64-bit environment with 32-bit compatibility
FROM ubuntu:10.04

ENV DEBIAN_FRONTEND=noninteractive
ENV G_SLICE=always-malloc
ENV G_DEBUG=gc-friendly

# 1. Fix the 404 Repository Errors
RUN sed -i 's|archive.ubuntu.com|old-releases.ubuntu.com|g' /etc/apt/sources.list && \
    sed -i 's|security.ubuntu.com|old-releases.ubuntu.com|g' /etc/apt/sources.list

# 2. Install 32-bit compatibility libraries (ia32-libs is the magic bullet here)
RUN apt-get update && apt-get install -y \
    ia32-libs \
    lib32asound2 \
    bzip2 \
    # Add these for the new errors:
    dbus-x11 \
    fontconfig \
    ttf-dejavu \
    libgconf2-4 \
    --no-install-recommends && \
    apt-get clean

# 3. Create the missing linker symlink (This solves the 'not found' error)
# The 32-bit linker on a 64-bit system is usually here:
RUN ln -s /lib32/ld-linux.so.2 /lib/ld-linux.so.2 || true

# 4. Copy and Extract Firefox
COPY --from=downloader /tmp/firefox.tar.bz2 /tmp/
RUN tar -jxvf /tmp/firefox.tar.bz2 -C /opt/ && rm /tmp/firefox.tar.bz2

# 5. Permissions and User
RUN useradd -m firefoxuser
RUN chown -R firefoxuser:firefoxuser /opt/firefox
USER firefoxuser
ENV HOME=/home/firefoxuser

# 6. Set Environment to use the extracted libraries
ENV LD_LIBRARY_PATH=/opt/firefox:/usr/lib32:/lib32
ENV PATH="/opt/firefox:${PATH}"

ENTRYPOINT ["firefox", "-no-remote"]
