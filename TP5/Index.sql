/* 
1. Les index automatiquement crees par Oracle sont 
les cles primaires et les cles uniques. 
*/
SELECT index_name, table_name, uniqueness
FROM USER_INDEXES;

SELECT index_name, column_name, column_position
FROM USER_IND_COLUMNS;

CREATE OR REPLACE VIEW USER_INDEXES AS
SELECT PK 
FROM ENSEIGNANT;
/*
2. Il est souhaitable de creer des index pour les colonnes contiennent l'attribute consultees regulierements 
*/
CREATE INDEX ID_GRPC 
ON GRPC
FROM GROUPE;
CREATE INDEX ID_NOM
ON NOM
FROM ENSEIGNANT;
CREATE INDEX ID_ENSEIGN
ON IDENSEIGN
FROM ENSEIGNER;
/*Pour le type de cours dans le tableau, on utilise B-tree pour  */
CREATE INDEX ID_TYPE
ON TYPEC
FROM CRENEAU;
/**/
DROP INDEX GROUPE.ID_GRPC;
DROP INDEX ENSEIGNANT.ID_NOM;
DROP INDEX ENSEIGNER.ID_ENSEIGN;
DROP INDEX CRENEAU.ID_TYPE;
