<?php

$dbVersion = null;
$dbInnodbVersion = null;
$dbProtocolVersion = null;
$dbError = null;

if (class_exists('\mysqli')) {
    $mysqli = new \mysqli('database', 'docker_test', 'docker_test', 'docker_test');
    $result = $mysqli->query('SHOW VARIABLES LIKE "%version%"');

    while ($row = $result->fetch_array(MYSQLI_NUM)) {
        if ($row[0] === 'version') {
            $dbVersion = $row[1];
        } elseif ($row[0] === 'innodb_version') {
            $dbInnodbVersion = $row[1];
        } elseif ($row[0] === 'protocol_version') {
            $dbProtocolVersion = $row[1];
        }
    }
} else {
    $dbError = 'Class "\mysqli" not found!';
}

?>
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
            table {
                border-collapse: collapse;
                border: 1px solid #999;
            }
            td, th {
                padding: 7px;
                border: 1px solid #999;
            }
            .error {
                padding: 15px;
                border: 1px solid #900;
                border-radius: 4px;
                background-color: #fcc;
            }
            .error:before {
                content: "ERROR:";
                display: inline-block;
                margin-right: 15px;
                color: #900;
                font-weight: bold;
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
            <p>PHP/FCGID, <?= preg_match('/(mariadb|mysql)/i', $dbVersion, $m) ? $m[1] : '&lt;UNKNOWN_DB&gt;' ?>, Apache - powered by <a href="https://docs.docker.com/"><b>Docker</b></a>.</p>
            <table>
                <tr>
                    <td>PHP</td>
                    <td><?= PHP_VERSION ?></td>
                </tr>
                <tr>
                    <td>Database</td>
                    <td><?= ($dbVersion ? $dbVersion : '&lt;UNKNOWN&gt;') ?></td>
                </tr>
                <tr>
                    <td>Apache</td>
                    <td><?= $_SERVER['SERVER_SOFTWARE'] ?></td>
                </tr>
            </table>
            <p>Web root directory in the container: <?= __DIR__ ?></p>
            <p><a href="pi.php">PHP Info</a></p>
            <p>Coolest solution ever! :)</p>
            <p>Based on article <a href="https://á.se/damp-docker-apache-mariadb-php-fpm/">DAMP – Docker, Apache, MariaDB &amp; PHP-FPM</a>.</p>
        </section>

        <section>
            <h2>Connect database from PHP</h2>
            <p>Use "<code>database</code>" (service name from "docker-compose.yml") as MySQL host name.</p>
            <p>For example:</p>
            <pre class="code">$mysqli = new \mysqli('database', 'docker_test', 'docker_test', 'docker_test');</pre>
        </section>

        <?php if (! empty($dbError)) : ?>
        <div class="error"><?= $dbError ?></div>
        <?php endif ?>
        
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

