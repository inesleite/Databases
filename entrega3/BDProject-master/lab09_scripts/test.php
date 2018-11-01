<html>
    <body>
<?php
    try
    {
    	$host = "db.ist.utl.pt";
        $user ="ist180967";
        $password = "hzan0912";
        $dbname = $user;
        
        $db = new PDO("mysql:host=$host;dbname=$dbname", $user, $password);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
        $sql = "select * from reserva";
    
        $result = $db->query($sql);
    
        echo("<table border=\"1\">\n");
        echo("<tr><td>balance</td></tr>\n");
        foreach($result as $row)
        {
            echo("<tr><td>");
            echo($row['numero']);
            echo("</td></tr>\n");
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
