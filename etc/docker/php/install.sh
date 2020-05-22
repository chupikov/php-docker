#!/bin/bash
# Install dependencies


## Install Composer

EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
wget -q https://getcomposer.org/installer -O composer-setup.php
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
mv composer.phar /usr/local/bin/composer
exit $RESULT
