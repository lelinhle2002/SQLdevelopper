CREATE OR REPLACE TRIGGER T_A_DIU_ENSEIGNER
AFTER INSERT OR DELETE
ON ENSEIGNER
FOR EACH ROW
DECLARE
    v_duree NUMBER;
    v_heurefc CRENEAU.HEUREFC%TYPE;
    v_type CRENEAU.TYPEC%TYPE :=0;
    v_coef NUMBER :=1;
BEGIN
    IF INSERTING OR UPDATING THEN
        SELECT HEUREFC, TYPEC
        INTO v_heurefc, v_type
        FROM CRENEAU
        WHERE DEBSEMC = :NEW.DEBSEMC
        AND JOURC = :NEW.JOURC
        AND HEUREDC = :NEW.HEUREDC
        AND GRPC = :NEW.GRPC;

        IF v_type = 'CM' THEN
            v_coef := 1.5;
        ELSIF v_type = 'TD' OR v_type = 'TP' THEN
            v_coef := 1;
        ELSE 
            v_coef := 0;
        END IF;

        v_duree := DUREE_CRENEAU(:NEW.HEUREDC, v_heurefc) * v_coef;

        UPDATE ENSEIGNANT
        SET NBHDISP = NVL(NBHDISP,0) + v_duree
        WHERE IDENSEIGN = :NEW.IDENSEIGN;
    END IF;
    IF DELETING OR UPDATING THEN
        SELECT HEUREFC, TYPEC
        INTO v_heurefc, v_type
        FROM CRENEAU
        WHERE DEBSEMC = :OLD.DEBSEMC
        AND JOURC = :OLD.JOURC
        AND HEUREDC = :OLD.HEUREDC
        AND GRPC = :OLD.GRPC;

        IF v_type = 'CM' THEN
            v_coef := 1.5;
        ELSIF v_type = 'TD' OR v_type = 'TP' THEN
            v_coef := 1;
        ELSE
            v_coef := 0;
        END IF;

        v_duree := DUREE_CRENEAU(:OLD.HEUREDC, v_heurefc) * v_coef;

        UPDATE ENSEIGNANT
        SET NBHDISP = NVL(NBHDISP,0) - v_duree
        WHERE IDENSEIGN = :OLD.IDENSEIGN;
    END IF;
END;
/