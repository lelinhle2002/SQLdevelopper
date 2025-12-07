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
SELECT * FROM ENSEIGNANT WHERE NOM = 'DU BELLAY';
CREATE INDEX ID_NOM ON ENSEIGNANT(NOM);
SELECT * FROM ENSEIGNANT WHERE NOM = 'DU BELLAY';
call dbms_stats.gather_schema_stats(user, 20);
EXPLAIN PLAN FOR
SELECT *
FROM ENSEIGNANT
WHERE NOM = 'DU BELLAY';
SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
    Afficher le plan d'execution
| Id  | Operation                           | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |            |     1 |    29 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| ENSEIGNANT |     1 |    29 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | ID_NOM     |     1 |       |     1   (0)| 00:00:01 |

L'utilisation d'index sur une colonne coûte légèrement plus cher qu'un recherche par clé primary
La clé primaire est crée automatique unique, Oracle utilise Index unique scan, il trouve exactement la ligne
immédiatement donc il est plus rapide. 
La recherche sur un index non automatique utilise Index range scan qui recherche dans l'index toutes les 
lignes correspondant à la valeur donnée. Si la valeur est répétée plusieur fois alors il peut y avoir plus ROWID à lire.
*/

select * from ENSEIGNANT, ENSEIGNER where ENSEIGNER.IDENSEIGN = ENSEIGNANT.IDENSEIGN ;
/*
Fetched 200 rows in 0.164 seconds pour index automatique
Fetched 200 rows in 0.167 seconds pour index ID_ENSEIGN
DROP INDEX ID_ENSEIGN;
--------------------------------------------------------------------------------------
| Id  | Operation             | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |              |  3087 |   180K|    12   (0)| 00:00:01 |
|*  1 |  HASH JOIN            |              |  3087 |   180K|    12   (0)| 00:00:01 |
|   2 |   TABLE ACCESS FULL   | ENSEIGNANT   |    60 |  1740 |     4   (0)| 00:00:01 |
|   3 |   INDEX FAST FULL SCAN| PK_ENSEIGNER |  3087 | 95697 |     8   (0)| 00:00:01 |
--------------------------------------------------------------------------------------

| Id  | Operation                            | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |            |  3087 |   180K|   747   (0)| 00:00:01 |
|*  1 |  HASH JOIN                           |            |  3087 |   180K|   747   (0)| 00:00:01 |
|   2 |   TABLE ACCESS FULL                  | ENSEIGNANT |    60 |  1740 |     4   (0)| 00:00:01 |
|   3 |   TABLE ACCESS BY INDEX ROWID BATCHED| ENSEIGNER  |  3087 | 95697 |   743   (0)| 00:00:01 |
|   4 |    INDEX FULL SCAN                   | ID_ENSEIGN |  3087 |       |     8   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------
ii) utilise l'orération 
*/
select grpc from GROUPE;
EXPLAIN PLAN FOR select * from ENSEIGNANT, ENSEIGNER where ENSEIGNER.IDENSEIGN = ENSEIGNANT.IDENSEIGN ;

CREATE INDEX ID_ENSEIGN ON ENSEIGNER(IDENSEIGN);
CALL dbms_stats.gather_schema_stats(user, 20);
EXPLAIN PLAN FOR
SELECT /*+ INDEX(en ID_ENSEIGN) */
       *
FROM ENSEIGNANT e
JOIN ENSEIGNER en ON en.IDENSEIGN = e.IDENSEIGN;
SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY());


EXPLAIN PLAN FOR
select CRENEAU.MATC, ENSEIGNER.IDENSEIGN,  
    sum((to_date(HEUREFC, 'HH24:MI') -
    to_date(CRENEAU.HEUREDC, 'HH24:MI')) * 24)    
from CRENEAU, ENSEIGNER 
where CRENEAU.DEBSEMC  = ENSEIGNER.DEBSEMC 
   and CRENEAU.JOURC  = ENSEIGNER.JOURC 
   and CRENEAU.HEUREDC  = ENSEIGNER.HEUREDC 
   and CRENEAU.GRPC   = ENSEIGNER.GRPC 
group by CRENEAU.MATC, ENSEIGNER.IDENSEIGN 
having sum((to_date(HEUREFC, 'HH24:MI') -  
    to_date(CRENEAU.HEUREDC, 'HH24:MI')) * 24)>  5; 

 /*
 ----------------------------------------------------------------------------------------
| Id  | Operation               | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT        |              |   155 | 11470 |    23   (5)| 00:00:01 |
|*  1 |  FILTER                 |              |       |       |            |          |
|   2 |   HASH GROUP BY         |              |   155 | 11470 |    23   (5)| 00:00:01 |
|*  3 |    HASH JOIN            |              |  3087 |   223K|    22   (0)| 00:00:01 |
|   4 |     INDEX FAST FULL SCAN| PK_ENSEIGNER |  3087 | 95697 |     8   (0)| 00:00:01 |
|   5 |     TABLE ACCESS FULL   | CRENEAU      |  4720 |   198K|    14   (0)| 00:00:01 |
----------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
| Id  | Operation              | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |              |  3087 |   204K|    23   (5)| 00:00:01 |
|   1 |  HASH GROUP BY         |              |  3087 |   204K|    23   (5)| 00:00:01 |
|*  2 |   HASH JOIN            |              |  3087 |   204K|    22   (0)| 00:00:01 |
|   3 |    INDEX FAST FULL SCAN| PK_ENSEIGNER |  3087 | 95697 |     8   (0)| 00:00:01 |
|   4 |    TABLE ACCESS FULL   | CRENEAU      |  4720 |   170K|    14   (0)| 00:00:01 |
---------------------------------------------------------------------------------------

 */
EXPLAIN PLAN FOR 
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
sum(1.5*(to_date(HEUREFC, 'HH24:MI')- to_date(ENSEIGNER.HEUREDC, 'HH24:MI'))*24)   
from CRENEAU, ENSEIGNER 
where TYPEC='CM'  
and ENSEIGNER.DEBSEMC   = CRENEAU.DEBSEMC 
and ENSEIGNER.JOURC   = CRENEAU.JOURC
and ENSEIGNER.HEUREDC   = CRENEAU.HEUREDC 
and ENSEIGNER.GRPC  = CRENEAU.GRPC 
group by IDENSEIGN 
union all 
select IDENSEIGN,  
sum((to_date(HEUREFC, 'HH24:MI')- to_date(ENSEIGNER.HEUREDC, 'HH24:MI'))*24)   
from CRENEAU , ENSEIGNER 
where  TYPEC in ('TD', 'TP') 
and ENSEIGNER.DEBSEMC   = CRENEAU.DEBSEMC 
and ENSEIGNER.JOURC  = CRENEAU.JOURC  
and ENSEIGNER.HEUREDC  = CRENEAU.HEUREDC 
and ENSEIGNER.GRPC   = CRENEAU.GRPC 
group by IDENSEIGN; 
update Enseignant  
set NbHDisp =(select sum(NbH) from NbHdispenseParEnseignant  where IdEns=IdEnseign); 
CALL DBMS_STATS.GATHER_SCHEMA_STATS(USER, 20);
EXPLAIN PLAN FOR
SELECT /*+ INDEX(en ID_ENSEIGN) */
*
FROM NbHdispenseParEnseignant;

SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY());
/*-----------------------------------------------------------------------------------------------------
| Id  | Operation                | Name                     | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |                          |   116 |  2088 |    46   (5)| 00:00:01 |
|   1 |  VIEW                    | NBHDISPENSEPARENSEIGNANT |   116 |  2088 |    46   (5)| 00:00:01 |
|   2 |   UNION-ALL              |                          |       |       |            |          |
|   3 |    HASH GROUP BY         |                          |    58 |  4060 |    23   (5)| 00:00:01 |
|*  4 |     HASH JOIN            |                          |   266 | 18620 |    22   (0)| 00:00:01 |
|*  5 |      TABLE ACCESS FULL   | CRENEAU                  |   407 | 15873 |    14   (0)| 00:00:01 |
|   6 |      INDEX FAST FULL SCAN| PK_ENSEIGNER             |  3087 | 95697 |     8   (0)| 00:00:01 |
|   7 |    HASH GROUP BY         |                          |    58 |  4060 |    23   (5)| 00:00:01 |
|*  8 |     HASH JOIN            |                          |  2635 |   180K|    22   (0)| 00:00:01 |
|   9 |      INDEX FAST FULL SCAN| PK_ENSEIGNER             |  3087 | 95697 |     8   (0)| 00:00:01 |
|* 10 |      TABLE ACCESS FULL   | CRENEAU                  |  4029 |   153K|    14   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------------------

*/
BEGIN 
DBMS_STATS.GATHER_TABLE_STATS( OWNNAME  => 'lwk4115a', 
TABNAME  => 'CRENEAU', 
METHOD_OPT  => 'FOR ALL COLUMNS SIZE AUTO', 
CASCADE  => true); 
END; 
SELECT COLUMN_NAME CN, DATA_TYPE DT, NUM_DISTINCT  
ND,LOW_VALUE LV, HIGH_VALUE HV, NUM_NULLS NN, 
AVG_COL_LEN ACL, SAMPLE_SIZE SS 
FROM USER_TAB_COLUMNS 
WHERE TABLE_NAME= 'CRENEAU'; 