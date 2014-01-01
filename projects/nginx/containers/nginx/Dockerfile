# arch-java
#
# base/arch with nginx
FROM base/arch
MAINTAINER David Parrish <daveparrish@gmail.com>

# Update the installation
RUN pacman -Syu --noconfirm

# Install nginx
RUN pacman -S --noconfirm nginx

# Configure and start nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx"]
