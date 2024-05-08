FROM alpine:3.19.1
RUN apk add sudo && \
    sed -i "s|# %wheel ALL=(ALL:ALL) NOPASSWD: ALL|%wheel ALL=(ALL:ALL) NOPASSWD: ALL|" /etc/sudoers && \
    adduser -u 1000 -G wheel -D vscode && \
    rm -rf /var/cache/apk/*
USER vscode
