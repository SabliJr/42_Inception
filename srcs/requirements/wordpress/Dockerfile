FROM debian:bookworm

# Install PHP-FPM and required PHP extensions
RUN apt update && apt-get upgrade -y  
RUN apt install -y php \
    php-fpm \
    php-mysqli \
    php-curl \
    php-json \
    php-mbstring \
    php-opcache \
    php-zip \
    curl \
    tar \
    unzip \
    iputils-ping \
    mariadb-client

# Set working directory
WORKDIR /var/www/html

# Download and extract latest WordPress directly into the workdir
RUN curl -o /wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf /wordpress.tar.gz --strip-components=1 -C . && \
    rm /wordpress.tar.gz

# Copy custom wp-config.php and setup script
COPY ./conf/wp_conf.php ./wp-config.php
COPY ./conf/wp_setup.sh /wp_setup.sh

# Make setup script executable
RUN chmod +x /wp_setup.sh

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Update php-fpm config to listen on all interfaces and pass environment variables
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf && \
    sed -i 's|^user = .*|user = www-data|' /etc/php/*/fpm/pool.d/www.conf && \
    sed -i 's|^group = .*|group = www-data|' /etc/php/*/fpm/pool.d/www.conf && \
    sed -i 's|;clear_env = no|clear_env = no|' /etc/php/*/fpm/pool.d/www.conf

# Create PHP-FPM run directory
RUN mkdir -p /run/php

# Expose FastCGI port
EXPOSE 9000

# Use the setup script as entrypoint
CMD ["/wp_setup.sh"]