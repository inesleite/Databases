<html>
    <body>
<?php
    $moradaEspaco = $_REQUEST['morada'];
    $codigoPosto = $_REQUEST['codigoPosto'];
    $codigoEspaco = $_REQUEST['codigoEspaco'];
    $operacao = $_REQUEST['operacao'];
    try
    {
        $host = "db.ist.utl.pt";
        $user ="ist180967";
        $password = "hzan0912";
        $dbname = $user;
        $db = new PDO("mysql:host=$host;dbname=$dbname", $user, $password);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $db->query("start transaction;");
        $sql = "temporary query";
        if ($operacao == "inserir") {
            $sql = "INSERT INTO posto VALUES ('$moradaEspaco','$codigoPosto', '$codigoEspaco');";
        }
        elseif ($operacao == "remover"){
            $sql = "DELETE FROM posto WHERE morada = '$moradaEspaco' AND codigo = '$codigoPosto' AND codigo_espaco = '$codigoEspaco';";
        }

        echo("<p>$sql</p>");

        $db->query($sql);

        $db->query("commit;");

        $db = null;
    }
    catch (PDOException $e)
    {
        $db->query("rollback;");
        echo("<p>ERROR: {$e->getMessage()}</p>");
    }
?>
    </body>
</html>
