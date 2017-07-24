FROM alpine
RUN apk update && \
	apk upgrade && \
	apk add wget && \
	apk add php5 php5-openssl php5-pdo php5-dom php5-opcache php5-xml php5-json php5-phar php5-pear php5-zip php5-mysql php5-pgsql ca-certificates && \
	rm /var/cache/apk/*
WORKDIR /var/www/html
RUN EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) && \
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") && \
	[ "$EXPECTED_SIGNATURE" == "$ACTUAL_SIGNATURE" ] && \
	php composer-setup.php --quiet && \
	rm -rf composer-setup.php && \
	mv composer.phar /usr/local/bin/composer
RUN	mkdir -p /var/www/html/ && composer create-project --prefer-dist laravel/laravel blog
ADD config/entrypoint.sh entrypoint.sh
RUN chmod u+x entrypoint.sh
EXPOSE 8008
ENTRYPOINT ["./entrypoint.sh"]
