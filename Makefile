up:
	./bin/start.sh
down:
	./bin/stop.sh
restart:
	./bin/stop.sh
	./bin/start.sh
build:
	./bin/build.sh
build-up:
	./bin/build.sh
	./bin/start.sh
init:
	./bin/init.sh
php-connect:
	./bin/php-connect.sh
mysql-connect:
	./bin/mysql-connect.sh
apache-connect:
	./bin/apache-connect.sh
apache-start:
	./bin/apache.sh start
apache-restart:
	./bin/apache.sh restart
apache-stop:
	./bin/apache.sh stop
