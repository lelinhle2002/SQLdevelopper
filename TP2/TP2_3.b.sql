CREATE TABLE DEPASSEMENT 
(
    IDENSEIGN CHAR(3),
    NOM VARCHAR2(30),
    PRENOM VARCHAR2(30),
    GRADE CHAR(4),
    NBHDISP NUMBER(5,2),
    MOTIF VARCHAR2(200) 
);

CREATE OR REPLACE TRIGGER T_B_U_ENSEIGNANT
AFTER UPDATE OF NBHDISP 
ON ENSEIGNANT
FOR EACH ROW
DECLARE 
    v_heures_compl NUMBER;
    v_heure_st NUMBER;
    v_mes VARCHAR2(200);
BEGIN
    IF :NEW.GRADE NOT IN ('PROF', 'MCF', 'PRAG', 'PRCE') THEN
        v_mes := 'Votre statut ne vous permet pas de faire des heures complémentaires.';
        INSERT INTO DEPASSEMENT(IDENSEIGN, NOM, PRENOM, GRADE, NBHDISP, MOTIF)
        VALUES (:NEW.IDENSEIGN, :NEW.NOM, :NEW.PRENOM, :NEW.GRADE, :NEW.NBHDISP, v_mes);
    END IF;

    SELECT NBHEURST
    INTO v_heure_st
    FROM STATUT
    WHERE GRADE = :NEW.GRADE;
    
    v_heures_compl := :NEW.NBHDISP - v_heure_st;

    IF v_heures_compl > (0.5 * v_heure_st) THEN
        v_mes := 'Le nombre d''heures complémentaires est de ' || v_heures_compl || 
                 ', vous êtes limité à ' || (0.5 * v_heure_st) || ' heures complémentaires.';
        INSERT INTO DEPASSEMENT(IDENSEIGN, NOM, PRENOM, GRADE, NBHDISP, MOTIF)
        VALUES (:NEW.IDENSEIGN, :NEW.NOM, :NEW.PRENOM, :NEW.GRADE, :NEW.NBHDISP, v_mes);
    END IF;
END;
/
