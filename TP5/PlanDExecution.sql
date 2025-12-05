EXPLAIN PLAN FOR
SELECT * FROM CRENEAU WHERE MATC = 'A1108';
SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY());


EXPLAIN PLAN FOR
SELECT NOM from ENSEIGNANT where IDENSEIGN='DBJ';

/*
    Pour la requete retournant le nom de l'enseignant d'id DBJ:
    il utilise l'opeation where (IDENSEIGN = 'DBJ).
    La requete balaye dans le tableau ENSEIGNANT et chercher dans la colonne IDENSEIGN = 'DBJ'

| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | SELECT STATEMENT            |               |     1 |    12 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| ENSEIGNANT    |     1 |    12 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_ENSEIGNANT |     1 |       |     0   (0)| 00:00:01 |
*/

CREATE INDEX ID_NOM ON ENSEIGNANT(NOM);
SELECT * FROM ENSEIGNANT WHERE NOM = 'DU BELLAY';
call dbms_stats.gather_sechma_stats(user, 20);

/*
    Afficher le plan d'execution
*/
select * from ENSEIGNANT, ENSEIGNER where ENSEIGNER.IDENSEIGN = ENSEIGNANT.IDENSEIGN 
CREATE INDEX ID_ENSEIGN ON IDENSEIGN FROM ENSEIGNER;

select * from table(dbms_xplan.display_cursor(sql_id=>'3cmz98rqfmnpb', format=>'ALLSTATS LAST'));


select CRENEAU.MATC, ENSEIGNER.IDENSEIGN,  
    sum((to_date(HEUREFC, 'HH24:MI') –  
    to_date(CRENEAU.HEUREDC, 'HH24:MI')) * 24)    
from CRENEAU, ENSEIGNER 
where CRENEAU.DEBSEMC  = ENSEIGNER.DEBSEMC 
   and CRENEAU.JOURC  = ENSEIGNER.JOURC 
   and CRENEAU.HEUREDC  = ENSEIGNER.HEUREDC 
   and CRENEAU.GRPC   = ENSEIGNER.GRPC 
group by CRENEAU.MATC, ENSEIGNER.IDENSEIGN 
having sum((to_date(HEUREFC, 'HH24:MI') -  
    to_date(CRENEAU.HEUREDC, 'HH24:MI')) * 24)>  5;

  
select CRENEAU.MATC, ENSEIGNER.IDENSEIGN, count(*)    
     from CRENEAU, ENSEIGNER 
 where CRENEAU.DEBSEMC  = ENSEIGNER.DEBSEMC 
   and CRENEAU.JOURC  = ENSEIGNER.JOURC 
   and CRENEAU.HEUREDC  = ENSEIGNER.HEUREDC 
   and CRENEAU.GRPC  = ENSEIGNER.GRPC 
group by CRENEAU.MATC, ENSEIGNER.IDENSEIGN; 

delete from ENSEIGNER 
where DEBSEMC  = '31/10/16' 
  and JOURC   = 'vendredi' 
  and HEUREDC  = '08:00' 
  and GRPC   = 'InS1A' 
  and IDENSEIGN = 'FUA' ; 
insert into ENSEIGNER values ('31/10/16', 'vendredi', '08:00',  
'InS1A', 'FUA') ; 

Create or replace view NbHdispenseParEnseignant(IdEns, NbH) 
as  
select IDENSEIGN,  
sum(1.5*(to_date(HEUREFC, 'HH24:MI')- 
to_date(ENSEIGNER.HEUREDC, 'HH24:MI'))*24)   
from CRENEAU, ENSEIGNER 
where TYPEC='CM'  
and ENSEIGNER.DEBSEMC   
= CRENEAU.DEBSEMC 
and ENSEIGNER.JOURC   
and ENSEIGNER.HEUREDC   
and ENSEIGNER.GRPC  
group by IDENSEIGN 
union all 
= CRENEAU.JOURC 
= CRENEAU.HEUREDC 
= CRENEAU.GRPC 
select IDENSEIGN,  
sum((to_date(HEUREFC, 'HH24:MI')- 
to_date(ENSEIGNER.HEUREDC, 'HH24:MI'))*24)   
from CRENEAU , ENSEIGNER 
where  TYPEC in ('TD', 'TP') 
and ENSEIGNER.DEBSEMC   
= CRENEAU.DEBSEMC 
and ENSEIGNER.JOURC   
and ENSEIGNER.HEUREDC  
and ENSEIGNER.GRPC   
group by IDENSEIGN; 
= CRENEAU.JOURC 
= CRENEAU.HEUREDC 
= CRENEAU.GRPC 
update Enseignant  
set NbHDisp =(select sum(NbH) 
from NbHdispenseParEnseignant  
where IdEns=IdEnseign); 