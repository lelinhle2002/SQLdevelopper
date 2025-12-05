CREATE OR REPLACE FUNCTION DUREE_CRENEAU (
    p_heuredc in CRENEAU.heuredc%TYPE,
    p_heurefc in CRENEAU.heurefc%TYPE
) RETURN NUMBER 
IS
    duree NUMBER;
BEGIN
    -- Calcule la durée en heures
    duree := (TO_DATE(p_heurefc, 'HH24:MI') - TO_DATE(p_heuredc, 'HH24:MI')) * 24;

    RETURN duree;
END;
commit;