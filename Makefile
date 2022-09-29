up:
	./bin/start.sh
down:
	./bin/stop.sh
restart:
	./bin/stop.sh
	./bin/start.sh
build:
	docker-compose build
init:
	./bin/init.sh
connect-php:
	./bin/connect-php.sh
connect-mysql:
	./bin/connect-mysql.sh
connect-apache:
	./bin/connect-apache.sh
