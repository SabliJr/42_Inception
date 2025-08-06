FROM debian:bookworm

# Install dependencies
RUN apt update && \
    apt install -y nginx openssl curl vim && \
    rm -rf /var/lib/apt/lists/*

# Create SSL directory and generate self-signed cert
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -out /etc/nginx/ssl/sabakar-.crt \
        -keyout /etc/nginx/ssl/sabakar-.key \
        -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=sabakar-/CN=sabakar-.42.fr"

# Copy your NGINX config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Ensure permissions are correct
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod 755 /var/www/html

# Expose HTTPS port
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
