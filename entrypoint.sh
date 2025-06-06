#!/bin/bash
set -e

PHP_FULL_VERSION=$(php -r 'echo phpversion();')
SIMPLE_PHPUNIT_PATH="${SIMPLE_PHPUNIT_PATH:-vendor/bin/simple-phpunit}"

if [ -z "$(ls)" ]; then
  echo "No code have been found.  Did you checkout with «actions/checkout» ?"
  exit 1
fi

if [ ! -d vendor/ ] || [ ! -f vendor/autoload.php ]; then
  echo "WARNING!!!: No autoload detected.";
  echo "Please add this snippet:
      - name: Install dependencies
        run: composer install --prefer-dist --no-progress --no-suggest"
  exit 1
fi

if [[ ! -f "$SIMPLE_PHPUNIT_PATH" ]]; then
  echo "ERROR: simple-phpunit is not found at «$SIMPLE_PHPUNIT_PATH»"
  echo "Set SIMPLE_PHPUNIT_PATH or add «symfony/phpunit-bridge» as a dev dependency"
  exit 1
fi

echo "## Installing git"
apt update
apt -yq install git

echo "## Installing composer"
curl -L https://getcomposer.org/composer-stable.phar -o /usr/bin/composer
chmod +x /usr/bin/composer

echo "## Running PHPUnit"
echo "PHP Version : ${PHP_FULL_VERSION}"
"$SIMPLE_PHPUNIT_PATH" --version

php -d memory_limit=-1 "$SIMPLE_PHPUNIT_PATH" --testdox
