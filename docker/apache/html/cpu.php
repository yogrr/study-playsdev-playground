<!DOCTYPE html>
<html>

<head>

    <title>Apache. Использование CPU</title>
    <meta http-equiv="refresh" content="1">

</head>

<body>

    <h1>Использование CPU</h1>

    <?php

    function getCpuUsage()
    {
        $output = shell_exec("top -bn1 | grep \"Cpu(s)\" | awk '{print $2 + $4}'");
        $cpu_usage = trim($output);

        if ($cpu_usage !== null && is_numeric($cpu_usage)) {
            return $cpu_usage;
        } else {
            return "Не удалось получить информацию об использовании CPU.";
        }
    }

    $cpu_usage = getCpuUsage();
    echo "<p>Использование CPU: " . $cpu_usage . "%</p>";

    ?>

</body>

</html>
