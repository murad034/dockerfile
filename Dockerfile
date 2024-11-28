FROM php:7.1-apache

LABEL Author="Zaman" Description="Prepared for HAJJ PILGRIM SEARCH"

# Install required system packages
RUN apt-get update && \
    apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    nano \
    vim \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure GD extension
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install and enable PHP extensions
RUN docker-php-ext-install gd pdo pdo_mysql zip

# Install Redis extension
RUN pecl install redis-4.3.0 && \
    docker-php-ext-enable redis

# Enable Apache modules
RUN a2enmod rewrite headers

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]

# Expose ports
EXPOSE 80 443