CREATE OR REPLACE TRIGGER T_A_U_CRENEAU
AFTER UPDATE OF HEUREFC, TYPEC
ON CRENEAU
FOR EACH ROW
DECLARE
  v_oldCoef NUMBER;
  v_newCoef NUMBER;
  v_oldDuree NUMBER;
  v_newDuree NUMBER;
BEGIN
  IF (:OLD.TYPEC IN ('CM','TD','TP')) OR (:NEW.TYPEC IN ('CM','TD','TP')) THEN

    -- coefficients
    v_oldCoef := CASE WHEN :OLD.TYPEC = 'CM' THEN 1.5 ELSE 1 END;
    v_newCoef := CASE WHEN :NEW.TYPEC = 'CM' THEN 1.5 ELSE 1 END;

    -- durées (sans faire de SELECT dans CRENEAU)
    v_oldDuree := DUREE_CRENEAU(:OLD.HEUREDC, :OLD.HEUREFC) * v_oldCoef;
    v_newDuree := DUREE_CRENEAU(:NEW.HEUREDC, :NEW.HEUREFC) * v_newCoef;

    -- mise à jour de ENSEIGNANT
    UPDATE ENSEIGNANT
    SET NBHDISP = NVL(NBHDISP, 0) + (v_newDuree - v_oldDuree)
    WHERE IDENSEIGN IN (
      SELECT IDENSEIGN
      FROM ENSEIGNER
      WHERE DEBSEMC = :NEW.DEBSEMC
        AND JOURC = :NEW.JOURC
        AND HEUREDC = :NEW.HEUREDC
        AND GRPC = :NEW.GRPC
    );
  END IF;
END;
/
