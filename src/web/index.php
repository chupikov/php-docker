<?php

$dbVersion = null;
$dbVersionComment = null;
$dbVersionId = null;
$dbInnodbVersion = null;
$dbProtocolVersion = null;
$dbError = null;

$yearMin = 2020;
$yearCur = (int) date('Y');

if (class_exists('\mysqli')) {
    $mysqli = new \mysqli('database', 'docker_test', 'docker_test', 'docker_test');
    $result = $mysqli->query('SHOW VARIABLES LIKE "%version%"');

    while ($row = $result->fetch_array(MYSQLI_NUM)) {
        if ($row[0] === 'version') {
            $dbVersion = $row[1];
        } elseif ($row[0] === 'version_comment') {
            $dbVersionComment = $row[1];
        } elseif ($row[0] === 'innodb_version') {
            $dbInnodbVersion = $row[1];
        } elseif ($row[0] === 'protocol_version') {
            $dbProtocolVersion = $row[1];
        }
    }

    if (preg_match('/(mariadb|mysql)/i', $dbVersion, $m)) {
        $dbVersionId = $m[1];
    } elseif (preg_match('/(mariadb|mysql)/i', $dbVersionComment, $m)) {
        $dbVersionId = $m[1];
    } else {
        $dbVersionId = '&lt;UNKNOWN_DB&gt;';
    }
} else {
    $dbError = 'Class "\mysqli" not found!';
}

$extLinks = [
    'gettext' => 'https://www.php.net/manual/en/function.gettext.php',
    'igbinary' => 'https://github.com/igbinary/igbinary',
    'xdebug' => 'https://xdebug.org/docs/',
    'zend opcache' => 'https://www.php.net/manual/en/book.opcache.php',
];
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>PHP <?= PHP_VERSION ?></title>
        <style>
            body {
                font-family: arial, helvetica, sans-serif;
                font-size: 16px;
                line-height: 1.7;
            }
            a {
                transition-duration: .3s;
                color: #007bff;
            }
            a:hover {
                color: #0056b3;
            }
            a.button {
                display: inline-block;
                padding: 1px 15px;
                color: #fff;
                background-color: #007bff;
                border: 1px solid #007bff;
                border-radius: 4px;
                text-decoration: none;
            }
            a.button:hover {
                border-color: #0069d9;
                background-color: #0069d9;
            }
            ol a, ul a {
                text-decoration: none;
            }
            table {
                border-collapse: collapse;
                border: 1px solid #999;
            }
            td, th {
                padding: 7px;
                border: 1px solid #999;
            }
            pre {
                margin: 15px 0;
                padding: 15px;
                border: 1px solid #ccc;
                border-radius: 4px;
                background-color: #f5f5f5;
            }
            .with-columns {
                columns: 200px auto;
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
        <h1>Docker for PHP</h1>
        <section>
            <p>
                PHP-FPM
                    <i>
                        (with<?php if (! extension_loaded('Zend OPcache')) : ?>out<?php endif ?> opcache,
                        with<?php if (! extension_loaded('xdebug')) : ?>out<?php endif ?> xdebug),
                    </i>
                <?= $dbVersionId ?>,
                Apache
                - powered by <a href="https://docs.docker.com/"><b>Docker</b></a>.
            </p>
            <p>Based on article <a href="https://á.se/damp-docker-apache-mariadb-php-fpm/">DAMP – Docker, Apache, MariaDB &amp; PHP-FPM</a>.</p>
            <table>
                <tr>
                    <td>PHP</td>
                    <td>
                        <?= PHP_VERSION ?>
                        <a href="pi.php" class="button" style="float:right">PHP Info</a>
                    </td>
                </tr>
                <tr>
                    <td>Database</td>
                    <td>
                        <?= ($dbVersion ? $dbVersion : '&lt;UNKNOWN&gt;') ?>
                        <?= ($dbVersionComment ? " - <i>$dbVersionComment</i>" : '') ?>
                    </td>
                </tr>
                <tr>
                    <td>Apache</td>
                    <td><?= $_SERVER['SERVER_SOFTWARE'] ?></td>
                </tr>
            </table>
            <p>Web root directory in the container: <?= __DIR__ ?></p>
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
                <li><a href="https://linoxide.com/linux-how-to/ssh-docker-container/" target="_blank">Using docker exec command</a></li>
                <li><strong><a href="https://docs.docker.com/">Docker</a></strong>:
                    <ul>
                        <li><a href="https://hub.docker.com/_/php">PHP</a></li>
                        <li><a href="https://hub.docker.com/_/mysql">MySQL</a></li>
                        <li><a href="https://hub.docker.com/_/mariadb">MariaDB</a></li>
                    </ul>
                </li>
            </ul>
        </section>

        <section>
            <h2>Available PHP extensions</h2>
            <ol class="with-columns">
                <?php
                $extensions = get_loaded_extensions();
                array_walk($extensions, static function(&$val){
                    $val = strtolower($val);
                });
                sort($extensions);
                foreach ($extensions as $ext) : ?>
                    <li>
                        <?php if (array_key_exists($ext, $extLinks)) : ?>
                            <a href="<?= $extLinks[$ext] ?>"><?= $ext ?></a>
                        <?php else : ?>
                            <?= $ext ?>
                        <?php endif ?>
                    </li>
                <?php endforeach ?>
            </ol>
        </section>

        <hr />

        <section>
            <ul class="copyright">
                <li>&copy; 2019 Nimpen J. Nordström</li>
                <li>&copy; <?= $yearMin . ($yearCur > $yearMin ? "-{$yearCur}" : '') ?> Yaroslav Chupikov</li>
            </ul>
        </section>
    </body>
</html>

