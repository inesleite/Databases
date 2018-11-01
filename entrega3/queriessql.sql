
/* Query a
SELECT distinct mydb.posto.morada FROM mydb.posto 
where (mydb.posto.morada,mydb.posto.codigo) not in 
(SELECT DISTINCT mydb.aluga.morada, mydb.aluga.codigo FROM mydb.aluga);



/* Query b
SELECT distinct mydb.aluga.morada from mydb.aluga group by mydb.aluga.morada having count(mydb.aluga.numero)>
 (SELECT AVG(valor) FROM 
 (SELECT count(mydb.aluga.numero) as valor from mydb.aluga group by mydb.aluga.morada) as S);

/* Query c
SELECT S.nif, S.nome, S.telefone, count(*) from 
(SELECT distinct A.nif, A.nome, A.telefone, C.id from mydb.user A, mydb.arrenda B, mydb.fiscaliza C
where A.nif=B.nif and C.morada=B.morada and C.codigo=B.codigo) S group by S.nif having count(*)=1
