FROM php:7.4-apache

# Install MySQLi
RUN docker-php-ext-install mysqli

# Install PHP Composer
RUN mkdir /composer/ \
    && cd /composer/ \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer