BEGIN 
DBMS_STATS.GATHER_TABLE_STATS( 
OWNNAME  
=> '<votre login>', 
TABNAME  
=> 'CRENEAU', 
METHOD_OPT  => 'FOR ALL COLUMNS SIZE AUTO', 
CASCADE  
=> true); 
END; 

SELECT COLUMN_NAME CN, DATA_TYPE DT, NUM_DISTINCT  
ND,LOW_VALUE LV, HIGH_VALUE HV, NUM_NULLS NN, 
AVG_COL_LEN ACL, SAMPLE_SIZE SS 
FROM USER_TAB_COLUMNS 
WHERE TABLE_NAME= 'CRENEAU'; 
/*
CN : Nom du colonne de tableau Creneau
DT : Le type de donnee de du colonne
ND : Nombre de valeur distinct
LV : La valeur min dans la colonne
HV : La valeur max dans la colonne
NN : Nombre de valeur null dans la colonne
ACL : La longueur moyenne de la colonne
SS : Nombre de lognes analysees pour les statistiques
*/

SELECT COLUMN_NAME CN, DATA_TYPE DT, NUM_DISTINCT ND, 
thierry_millan.GET_INFO (DATA_TYPE, LOW_VALUE)  LV, 
thierry_millan.GET_INFO (DATA_TYPE, HIGH_VALUE) HV,  
NUM_NULLS NN, AVG_COL_LEN ACL, SAMPLE_SIZE SS 
FROM USER_TAB_COLUMNS 
WHERE TABLE_NAME= 'CRENEAU';