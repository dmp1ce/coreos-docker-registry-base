FROM base/arch
MAINTAINER David Parrish <daveparrish@gmail.com>

RUN pacman -Syu --noconfirm

# Install yaourt for AUR packages
RUN echo -e "[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
RUN pacman -Sy --noconfirm base-devel yaourt

# Install requirements for repository
RUN ln -s /proc/self/fd /dev/fd	# Fixes error with missing /dev/fd
RUN yaourt -S --noconfirm nginx etcd jq

# Create persistant data location
RUN mkdir /data
RUN chmod 777 /data
VOLUME ["/data"]

# Link data files that need to be added manually
RUN ln -s /data/etc/ssl/certs/docker-registry.crt /etc/ssl/certs/docker-registry.crt
RUN ln -s /data/etc/ssl/private/docker-registry.key /etc/ssl/private/docker-registry.key

# Add the nginx config
RUN mkdir -p /root/deploy/etc/nginx
ADD etc/nginx/nginx.conf /root/deploy/etc/nginx/nginx.conf

# Add prepare_nginx script
ADD prepare_nginx.sh /root/deploy/prepare_nginx.sh
RUN chmod +x /root/deploy/prepare_nginx.sh

# Prepare config and run nginx in foreground
ENTRYPOINT /root/deploy/prepare_nginx.sh && /usr/sbin/nginx -c /etc/nginx/nginx.conf
