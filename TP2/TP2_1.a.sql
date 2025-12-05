CREATE OR REPLACE TRIGGER T_B_IU_AFFECTER_CAP
BEFORE INSERT OR UPDATE 
ON AFFECTER 
FOR EACH ROW
DECLARE
    v_eff GROUPE.EFF%TYPE;
    v_capacite SALLE.CAPACITE%TYPE;
BEGIN
    SELECT EFF INTO v_eff
    FROM GROUPE
    WHERE GRPC = :NEW.GRPC;
    
    SELECT CAPACITE INTO v_capacite 
    FROM SALLE
    WHERE NSALLE = :NEW.NSALLE;
    
    IF (v_eff > v_capacite)
    THEN
        RAISE_APPLICATION_ERROR(-20002, ' la capacité de la salle est inférieure à l''effectif du groupe');
    END IF;
END;
/