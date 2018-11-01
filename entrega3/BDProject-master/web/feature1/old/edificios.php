<html>
    <body>
    <h3>Inserir Edificios</h3>
        <form action="updateEdificios.php" method="post">
            <p><input type="hidden" name="operacao" value="inserir"/></p>
            <p>Morada do Edificio: <input type="text" name="morada" required/><input type="submit" value="Submit"/></p>
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
    
        $sql = "SELECT * FROM edificio;";
    
        $result = $db->query($sql);
        echo("<h3>Remover Edificios</h3>");
        echo("<table border=\"1\" cellspacing=\"5\">");
        echo("<th>Morada</th>");
        foreach($result as $row)
        {
            echo("<tr>\n");
            echo("<td>{$row['morada']}</td>\n");
            echo("<td><a href=\"updateEdificios.php?morada={$row['morada']}&operacao=remover\">Remover</a></td>\n");
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