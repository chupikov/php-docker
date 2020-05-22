#!/bin/bash
# Install dependencies

declare -A files
files=(
    ["zopflipng"]="https://github.com/imagemin/zopflipng-bin/raw/master/vendor/linux/zopflipng"
    ["pngcrush"]="https://github.com/imagemin/pngcrush-bin/raw/master/vendor/linux/pngcrush"
    ["jpegoptim"]="https://github.com/imagemin/jpegoptim-bin/raw/master/vendor/linux/jpegoptim"
    ["pngout"]="https://github.com/imagemin/pngout-bin/raw/master/vendor/linux/x64/pngout"
    ["advpng"]="https://github.com/imagemin/advpng-bin/raw/master/vendor/linux/advpng"
    ["cjpeg"]="https://github.com/imagemin/mozjpeg-bin/raw/master/vendor/linux/cjpeg"
)


## Install Composer

echo "Install Composer..."

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


## Install listed dependencies

for file in "${!files[@]}"; do
  url=${files[$file]}
  filename="/usr/local/bin/${file}"
  echo "Install '${filename}'..."
  wget -q "${url}" -O "${filename}"
  chmod 0755 "${filename}"
done
