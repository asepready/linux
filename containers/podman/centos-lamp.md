# Install LAMP Stack on RHEL 9 | CentOS 9 Using Podman

# Step 1: Create a Pod
```sh
podman pod create --name my-lamp-pod -p 9601:443 -p 5432:5432
```
# Step 2: Build a LAMP stack image
```sh
vim Containerfile
# Use a UBI/RHEL 9 base image
FROM registry.access.redhat.com/ubi9/ubi

# Install Nginx and PHP-FPM
RUN dnf install -y \
    nginx \
    php \
    php-fpm \
    php-mysqlnd \
    && dnf clean all

# Create the PHP-FPM socket directory
RUN mkdir -p /run/php-fpm && \
    chown -R nginx:nginx /run/php-fpm

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy SSL certificates (if needed)
COPY server.crt /etc/ssl/certs/server.crt
COPY server.key /etc/ssl/private/server.key

# Set permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose ports
EXPOSE 80
EXPOSE 443

# Start both Nginx and PHP-FPM
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]

podman build -t lamp-centos:latest .
```
# Step 3: Run the Application Container
```sh
podman run -d --pod my-lamp-pod --name my-web-container -v /path/to/directory:/var/www/html lampstack:latest
```
# Step 4: Run the PostgreSQL Container
```sh
podman run -d --rm --pod my-lamp-pod --name my-db-container -e POSTGRES_USER=testuser -e POSTGRES_PASSWORD=pgpass_test_123 -e POSTGRES_DATABASE=login -v /path/to/directory/pgdata:/var/lib/postgresql/data:Z docker.io/postgres

podman exec -it my-db-container psql -U testuser -d login
```

# Troubleshooting Common Issues
```sh
sudo firewall-cmd --permanent --add-port=80/tcp --add-port=443/tcp --add-port=9601/tcp
sudo firewall-cmd --reload
```