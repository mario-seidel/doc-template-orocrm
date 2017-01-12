#!/bin/bash

USER_ID=${HOST_USER_ID:-9001}
USER_NAME=${HOST_USER:-user}
GROUP_ID=${HOST_GROUP_ID:-9001}
GROUP_NAME=${HOST_GROUP:-group}

echo "Starting with UID: $USER_ID and GID: $GROUP_ID"
groupadd -g $GROUP_ID -o $GROUP_NAME \
	&& useradd --shell /bin/bash -u $USER_ID -o -c "" -g $GROUP_ID -m $HOST_USER
export HOME=/home/$HOST_USER

echo "run composer install/update"
if [ -e composer.lock ]; then
	php -d allow_url_fopen=on /usr/local/bin/composer.phar self-update \
		&&	su -c 'php -d allow_url_fopen=on /usr/local/bin/composer.phar install --prefer-source' $HOST_USER
else
    su -c 'php -d allow_url_fopen=on /usr/local/bin/composer.phar global require fxp/composer-asset-plugin:1.2.2' $HOST_USER
	php -d allow_url_fopen=on /usr/local/bin/composer.phar self-update \
		&&	su -c 'php -d allow_url_fopen=on /usr/local/bin/composer.phar update --prefer-stable --prefer-source' $HOST_USER
fi

echo -e "============= starting webserver with ENV $APP_ENV ============="

if [ -f FIRST_INSTALL ]; then
	echo "Install ORO APP"
	rm -rf app/cache/*
	php app/console oro:install --env prod \
		--application-url $APPLICATION_URL\
		--organization-name $ORGANIZATION_NAME \
		--user-name $USER_NAME \
		--user-email $USER_EMAIL \
		--user-firstname $USER_FIRSTNAME \
		--user-lastname $USER_LASTNAME \
		--user-password $USER_PASSWORD \
		--sample-data $SAMPLE_DATA \
		--force \
		--symlink \
		--drop-database \
		--no-interaction && \
	rm -f FIRST_INSTALL
fi

rm -rf app/cache/*

php app/console clank:server --env $APP_ENV &
php app/console server:run $(/sbin/ip route|awk '/scope/ { print $9 }'):8000 --env $APP_ENV