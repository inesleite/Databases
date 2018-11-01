/* Query a
-Quais os espacos com postos que nunca foram alugados
*/
SELECT distinct morada, codigo_espaco 
FROM posto
where (morada, codigo) not in(
	SELECT DISTINCT A.morada, A.codigo FROM aluga A, estado B 
	where A.numero=B.numero
	AND B.estado="ACEITE");

/* Query b 
-Quais edificios com um numero de reservas superior a media?
*/
SELECT distinct morada 
FROM aluga
GROUP BY morada 
having count(numero) > (SELECT AVG(valor)
                        FROM(
                          SELECT count(numero) as valor
                          FROM aluga
                          group by morada
                          ) as S);

/* Query c 
-Quais utilizadores cujos alugaveis foram fiscalizados sempre pelo mesmo fiscal 
*/
SELECT S.nif
FROM (
	SELECT distinct user.nif, fiscaliza.id
	FROM user, arrenda, fiscaliza
	where user.nif=arrenda.nif and fiscaliza.morada=arrenda.morada and fiscaliza.codigo=arrenda.codigo
  ) as S
group by S.nif 
having count(S.id)=1;


/* Query d
-Qual o montante total realizado (pago) por cada espaço durante o ano de 2016?
	(Assuma que a tarifa indicada na oferta é diária. Deve considerar os casos em que o
	espaço foi alugado totalmente ou por postos.)
*/
/*SELECT S.morada, S.codigo, SUM(S.total) as totalRealizado
	FROM (
    SELECT espaco.morada, espaco.codigo, SUM(oferta.tarifa * (oferta.data_fim - oferta.data_inicio)) as total
		FROM espaco NATURAL JOIN aluga NATURAL JOIN oferta NATURAL JOIN paga
        GROUP BY espaco.morada, espaco.codigo) AS S
	GROUP BY S.morada, S.codigo;*/
SELECT Res.morada, Res.codigo, SUM(Res.total) as totalRealizado
FROM( ( SELECT S.morada, S.codigo, SUM(S.total) AS total
        FROM(( SELECT morada, codigo, SUM(tarifa * (data_fim - data_inicio)) AS total
               FROM espaco NATURAL JOIN aluga NATURAL JOIN oferta NATURAL JOIN paga
               WHERE year(paga.data) = '2016'
               GROUP BY morada, codigo)
             UNION
             ( SELECT morada, codigo_espaco, SUM(tarifa * (data_fim - data_inicio)) AS total
               FROM posto NATURAL JOIN aluga NATURAL JOIN oferta NATURAL JOIN paga
               WHERE year(paga.data) = '2016'
               GROUP BY morada, codigo)
        ) AS S
        GROUP BY morada, codigo)
        UNION
      ( SELECT morada, codigo, 0 AS total FROM espaco )
) AS Res
GROUP BY morada, codigo;
/*
Query e
- Quais os espaços de trabalho cujos postos nele contidos foram todos alugados?
	(Por alugado entende-se um posto de trabalho que tenha pelo menos uma oferta aceite,
	independentemente das suas datas.)
*/
SELECT distinct morada, codigo_espaco
	FROM posto
	where(morada, codigo_espaco) not in (
		SELECT distinct morada, codigo_espaco
			FROM posto
			where (morada, codigo) not in(
				SELECT DISTINCT A.morada, A.codigo
				FROM aluga A, estado B
				where A.numero=B.numero AND B.estado= 'Aceite' ));





