CREATE OR REPLACE TRIGGER T_B_U_ENSEIGNANT
BEFORE UPDATE OF NBHDISP 
ON ENSEIGNANT
FOR EACH ROW
DECLARE 
    v_heures_compl NUMBER;
    v_heure_st NUMBER;
BEGIN
    IF :NEW.GRADE NOT IN ('PROF', 'MCF', 'PRAG', 'PRCE') THEN
        RAISE_APPLICATION_ERROR(-20010,'votre statut ne vous permet pas de faire des heures complémentaires.');
    END IF;

    SELECT NBHEURST
    INTO v_heure_st
    FROM STATUT
    WHERE GRADE = :NEW.GRADE;
    
    v_heures_compl := :NEW.NBHDISP - v_heure_st;

    IF v_heures_compl > (0.5 * v_heure_st) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Le nombre d''heures complémentaires est de' || v_heures_compl ||' vous êtes limités à  ' || (0.5 * v_heure_st) || ' heures  complémentaire.');
    END IF;
END;
/
