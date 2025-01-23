# Use PHP 8.2 with Apache
FROM php:8.2-apache

LABEL Author="Murad" Description="Prepared for HAJJ PORTAL PHP 8.2 and Node.js support"

# Install required system packages
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    libzip-dev \
    zip \
    unzip \
    nano \
    vim \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure GD extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install and enable PHP extensions
RUN docker-php-ext-install gd pdo pdo_mysql zip mbstring exif

# Install Redis extension
RUN pecl install redis && \
    docker-php-ext-enable redis

# Enable Apache modules
RUN a2enmod rewrite headers

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]

# Expose ports
EXPOSE 80 443