<html>
    <body>
    <h3>Inserir Espaços</h3>
        <form action="updateEspacos.php" method="post">
            <p><input type="hidden" name="operacao" value="inserir"/></p>
            <p>Morada do Espaço: <input type="text" name="morada" required/></p>
            <p>Código do Espaço: <input type="text" name="codigoEspaco" required/></p>
            <p><input type="submit" value="Submit"/></p>
        </form>
<?php
    try
    {
        $host = "db.ist.utl.pt";
        $user ="ist180967";
        $password = "hzan0912";
        $dbname = $user;
    
        $db = new PDO("mysql:host=$host;dbname=$dbname", $user, $password);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
        $sql = "SELECT * FROM espaco;";
    
        $result = $db->query($sql);
        echo("<h3>Remover Espaços</h3>");
        echo("<table border=\"1\" cellspacing=\"5\">");
        echo("<th>Morada</th><th>Código</th>");
        foreach($result as $row)
        {
            echo("<tr>\n");
            echo("<td>{$row['morada']}</td>\n");
            echo("<td>{$row['codigo']}</td>\n");
            echo("<td><a href=\"updateEspacos.php?morada={$row['morada']}&codigoEspaco={$row['codigo']}&operacao=remover\">Remover</a></td>\n");
            echo("</tr>\n");
        }
        echo("</table>\n");
    
        $db = null;
    }
    catch (PDOException $e)
    {
        echo("<p>ERROR: {$e->getMessage()}</p>");
    }
?>
    </body>
</html>