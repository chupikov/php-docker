<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>PHP <?= PHP_VERSION ?></title>
        <style>
            body {
                font-family: arial, helvetica, sans-serif;
                font-size: 18px;
            }
            .copyright {
                list-style: none;
                margin: 0;
                padding: 0;
                color: #999;
                font-size: 12px;
            }
        </style>
    </head>
    <body>
        <h1>Whoa!!!</h1>
        <section>
            <p>PHP <?= PHP_VERSION ?>/FCGID, MariaDB, Apache - powered by <a href="https://docs.docker.com/"><b>Docker</b></a>.</p>
            <p>Web root directory in the container: <?= __DIR__ ?></p>
            <p><a href="pi.php">PHP Info</a></p>
            <p>Coolest solution ever! :)</p>
            <p>Based on article <a href="https://á.se/damp-docker-apache-mariadb-php-fpm/">DAMP – Docker, Apache, MariaDB &amp; PHP-FPM</a>.</p>
        </section>
        
        <section>
            <h2>Information</h2>
            <ul>
                <li>Environment configured according to article <a href="https://á.se/damp-docker-apache-mariadb-php-fpm/" target="_blank">DAMP – Docker, Apache, MariaDB & PHP-FPM</a>.
                <li><a href="https://linoxide.com/linux-how-to/ssh-docker-container/" target="_blank">Using docker exec command</a>
            </ul>
        </section>

        <hr />
        
        <section>
            <ul class="copyright">
                <li>&copy; 2019 Nimpen J. Nordström</li>
                <li>&copy; 2020 Yaroslav Chupikov</li>
            </ul>
        </section>
    </body>
</html>

