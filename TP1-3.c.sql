CREATE OR REPLACE FUNCTION EST_CRENEAU_DISJOINT (
    heurede1  IN CRENEAU.HEUREDC%TYPE,
    heurefin1 IN CRENEAU.HEUREFC%TYPE,
    heurede2  IN CRENEAU.HEUREDC%TYPE,
    heurefin2 IN CRENEAU.HEUREFC%TYPE
) RETURN VARCHAR2
IS
BEGIN
    IF (TO_DATE(heurede1, 'HH24:MI') > TO_DATE(heurefin1, 'HH24:MI'))
    THEN
        RAISE_APPLICATION_ERROR(-20100, 'L heure de debut du premier creneau doit etre strictement anterieure a celle de la fin du creneau');
    ELSIF (TO_DATE(heurede2, 'HH24:MI') > TO_DATE(heurefin2, 'HH24:MI'))
    THEN
        RAISE_APPLICATION_ERROR(-20101, 'L heure de debut du second creneau doit être strictement anterieure a celle de la fin du creneau');
    END IF;
    IF (TO_DATE(heurefin1, 'HH24:MI') <= TO_DATE(heurede2, 'HH24:MI')) OR (TO_DATE(heurefin2, 'HH24:MI') <= TO_DATE(heurede1, 'HH24:MI'))
    THEN
        RETURN 'TRUE';
    ELSE
        RETURN 'FALSE';
    END IF;
END;
/