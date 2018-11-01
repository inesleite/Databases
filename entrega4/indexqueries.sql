
show profiles;
set PROFILING = 1;

explain select A.nif
from arrenda A
inner join fiscaliza F
on A.morada = F.morada and A.codigo = F.codigo
group by A.nif
having count(distinct F.id)=1;

show index from arrenda;
show index from fiscaliza;

create index fiscalizaid_idx on fiscaliza(id);
drop index fiscalizaid_idx on fiscaliza;

create index arrenda_idx on arrenda(morada, codigo, nif);
drop index arrenda_idx on arrenda;


explain select distinct P.morada, P.codigo_espaco
from posto P
where (P.morada, P.codigo_espaco) not in (
  select P.morada, P.codigo_espaco
  from posto P natural join aluga A natural join estado E
  where E.estado = 'aceite');

show profiles;
show index from posto;
show index from aluga;
show index from estado;

create index estado_idx on estado(estado);

drop index morada on posto;