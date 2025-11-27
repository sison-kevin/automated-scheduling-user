FROM php:8.2-apache

# Install PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Allow .htaccess overrides
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Copy the actual LavaLust application into Apache document root.
# The repository contains the app under `Userpanel-web_project/LavaLust-dev-v4`.
# Adjust this path if your project layout differs in the remote build context.
## Copy the actual app. Some repository layouts place the app in a nested
## `Userpanel-web_project/Userpanel-web_project/LavaLust-dev-v4/` folder.
## Use that nested path which contains the real front controller `index.php`.
COPY Userpanel-web_project/Userpanel-web_project/LavaLust-dev-v4/ /var/www/html/

# Set a global ServerName to suppress the AH00558 warning from Apache.
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Fix permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Ensure Apache will look for index.php first
RUN sed -i 's/DirectoryIndex .*$/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf || true

EXPOSE 80