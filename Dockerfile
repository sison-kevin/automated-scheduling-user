FROM php:8.2-apache

# Install PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Allow .htaccess overrides
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Copy the application folder (LavaLust app) into Apache document root
# Adjust this path if your application is located elsewhere in the repo
COPY Userpanel-web_project/Userpanel-web_project/LavaLust-dev-v4/ /var/www/html/

# Set a global ServerName to suppress Apache warning and ensure proper virtual host resolution
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Fix permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80