SELECT A.nif
FROM mydb.arrenda A 
	inner join mydb.fiscaliza F 	
    on A.morada = F.morada
    AND A.codigo = F.codigo
GROUP BY A.nif 
HAVING COUNT(DISTINCT F.id )= 1;


SELECT DISTINCT P.morada, P.codigo_espaco
FROM mydb.posto P
WHERE (P.morada, P.codigo_espaco) NOT IN (
	SELECT P.morada, P.codigo_espaco
    FROM mydb.posto P
		NATURAL JOIN mydb.aluga A
        NATURAL JOIN mydb.estado E 
	WHERE E.estado = "Aceite");