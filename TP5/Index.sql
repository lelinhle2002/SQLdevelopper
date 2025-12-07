/* 
1. Les index automatiquement crees par Oracle sont 
les cles primaires et les cles uniques. 
*/
SELECT index_name, table_name, uniqueness
FROM USER_INDEXES;

SELECT index_name, column_name, column_position
FROM USER_IND_COLUMNS;

/*
2. Il est souhaitable de creer des index pour les colonnes contiennent l'attribute consultees regulierements 
*/
CREATE INDEX ID_GRPC 
ON CRENEAU(GRPC);
CREATE INDEX ID_NOM
ON ENSEIGNANT(NOM);
CREATE INDEX ID_ENSEIGN
ON ENSEIGNER(IDENSEIGN);
/*Pour le type de cours dans le tableau, on utilise Bitmap parce que la colonne comporte seulement 7 valeurs. 
Type bitmaps est puissant pour les requetes avec les conditions WHERE, AND, OR.*/
CREATE BITMAP INDEX ID_TYPE
ON CRENEAU(TYPEC);
/**/
DROP INDEX ID_GRPC;
DROP INDEX ID_NOM;
DROP INDEX ID_ENSEIGN;
DROP INDEX ID_TYPE;
