CREATE OR REPLACE FUNCTION GET_ENSEIGNANT 
    ( P_NOM IN ENSEIGNANT.NOM%TYPE,
    P_PRENOM IN ENSEIGNANT.PRENOM%TYPE) RETURN VARCHAR2 IS
    e_code ENSEIGNANT.IDENSEIGN%TYPE;
    BEGIN
        BEGIN 
            SELECT IDENSEIGN
            INTO e_code
            FROM ENSEIGNANT
            WHERE ENSEIGNANT.NOM = P_NOM 
            AND
            ENSEIGNANT.PRENOM = P_PRENOM;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                e_code := NULL;
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(-20103,'Au moins deux enseignants s''appellent ' || P_PRENOM || ' ' || P_NOM);
        END;
        RETURN e_code;
END;   
/