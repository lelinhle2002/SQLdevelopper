CREATE OR REPLACE FUNCTION NBHDISPTOTAL 
RETURN NUMBER
IS
    v_heureTotal NUMBER;
BEGIN
    SELECT SUM(NBHDISP)
    INTO v_heureTotal
    FROM ENSEIGNANT;

    IF v_heureTotal IS NULL
    THEN
        v_heureTotal  := 0;
    END IF;

    RETURN v_heureTotal;
END;
/