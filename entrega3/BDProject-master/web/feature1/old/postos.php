<html>
    <body>
    <h3>Inserir Posto</h3>
        <form action="updatePostos.php" method="post">
            <p><input type="hidden" name="operacao" value="inserir"/></p>
            <p>Morada do Posto: <input type="text" name="morada" required/>
            <p>Código do Posto: <input type="text" name="codigoPosto" required/></p>
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
    
        $sql = "SELECT * FROM posto;";
    
        $result = $db->query($sql);
        echo("<h3>Remover Posto</h3>");
        echo("<table border=\"1\" cellspacing=\"5\">");
        echo("<th>Morada</th><th>Código do Posto</th><th>Código do Espaço</th>");
        foreach($result as $row)
        {
            echo("<tr>\n");
            echo("<td>{$row['morada']}</td>\n");
            echo("<td>{$row['codigo']}</td>\n");
            echo("<td>{$row['codigo_espaco']}</td>\n");
            echo("<td><a href=\"updatePostos.php?morada={$row['morada']}&codigoPosto={$row['codigo']}&codigoEspaco={$row['codigo_espaco']}&operacao=remover\">Remover</a></td>\n");
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