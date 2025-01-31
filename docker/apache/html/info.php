<!DOCTYPE html>
<html>

<head>

    <title>Apache. Переменные среды. Информация о PHP</title>

</head>

<body>

    <?php

    echo "PHP Version: " . phpversion() . "\n";
    echo "SAPI: " . php_sapi_name() . "\n";

    $port = getenv('PORT');

    if ($port !== false) {
        echo "Значение переменной PORT: " . $port . "\n";
    } else {
        echo "Переменная PORT не установлена.\n";
    }

    $test_env = getenv('TEST_ENV');

    if ($test_env !== false) {
        echo "Значение переменной test_env: " . $test_env . "\n";
    } else {
        echo "Переменная test_env не установлена.\n";
    }

    phpinfo();

    ?>

</body>

</html>