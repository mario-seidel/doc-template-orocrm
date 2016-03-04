#!/bin/bash

echo -e "============= starting webserver with ENV $APP_ENV ============="

#chgrp -R www-data /var/www/html

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

php app/console clank:server --env $APP_ENV &
php app/console server:run $(/sbin/ip route|awk '/scope/ { print $9 }'):8000 --env $APP_ENV