CREATE OR REPLACE FUNCTION EST_CRENEAU_DISJOINT (
    heurede1  IN CRENEAU.HEUREDC%TYPE,
    heurefin1 IN CRENEAU.HEUREFC%TYPE,
    heurede2  IN CRENEAU.HEUREDC%TYPE,
    heurefin2 IN CRENEAU.HEUREFC%TYPE
) RETURN VARCHAR2
IS
BEGIN
--Exception
    IF (TO_DATE(heurede1, 'HH24:MI') > TO_DATE(heurefin1, 'HH24:MI'))
    THEN
        RAISE_APPLICATION_ERROR(-20100, 'L heure de debut du premier creneau doit etre strictement anterieure a celle de la fin du creneau');
    ELSIF (TO_DATE(heurede2, 'HH24:MI') > TO_DATE(heurefin2, 'HH24:MI'))
    THEN
        RAISE_APPLICATION_ERROR(-20101, 'L heure de debut du second creneau doit être strictement anterieure a celle de la fin du creneau');
    END IF;
    
    
    
--Traitement  
    IF (TO_DATE(heurefin1, 'HH24:MI') <= TO_DATE(heurede2, 'HH24:MI')) OR (TO_DATE(heurefin2, 'HH24:MI') <= TO_DATE(heurede1, 'HH24:MI'))
    THEN
        RETURN 'TRUE';
    ELSE
        RETURN 'FALSE';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE = -1861 THEN
            RAISE_APPLICATION_ERROR(-20102,'Le format de l heure de début ou de fin doit être HH24:MM');
    ELSIF SQLCODE = -1850 THEN
            RAISE_APPLICATION_ERROR(-20120,'Le format de l heure de début ou de fin doit être HH24:MM. L’heure doit être comprise entre 00 et 23');
    ELSIF SQLCODE = -1851 THEN
            RAISE_APPLICATION_ERROR(-20121,'Le format de l heure de début ou de fin doit être HH24:MM. Les minutes doivent être comprise entre 00 et 59');
    END IF;
END;
/