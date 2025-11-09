CREATE OR REPLACE FUNCTION GET_SALLE_DISP (
    P_DEBSEMC  IN CRENEAU.HEUREDC%TYPE,
    P_JOURC IN CRENEAU.HEUREFC%TYPE,
    P_HEUREDC  IN CRENEAU.HEUREDC%TYPE,
    P_GRPC IN CRENEAU.HEUREFC%TYPE,
    P_TYPEC IN CRENEAU.TYPEC%TYPE
) RETURN VARCHAR2
IS
    v_date_heure DATE;
    v_taille NUMBER;
    v_salle SALLE.NSALLE%TYPE;
BEGIN
    IF (P_DEBSEMC IS NULL OR P_JOURC IS NULL OR P_HEUREDC IS NULL OR P_GRPC IS NULL OR P_TYPEC IS NULL) 
    THEN
        RAISE_APPLICATION_ERROR(-20104, 'Tous les parametres doivent etre renseignes');
    END IF;
    
    BEGIN
        v_date_heure := TO_DATE(P_HEUREDC,'HH24:MI');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20102, 'Le format de l heure de debut ou de fin doit etre HH:MI');
    END;
    
    BEGIN
        SELECT EFF
        INTO v_taille
        FROM GROUPE
        WHERE GRPC = P_GRPC;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20105, 'GROUPE ' ||P_GRPC ||' INEXISTANT');
    END;
    
    FOR sal in (SELECT * FROM SALLE ORDER BY CAPACITE) 
    LOOP
        IF P_TYPEC = 'TP' THEN
            IF sal.TSAL = 'TP' AND sal.CAPACITE >= v_taille THEN
                v_salle:= sal.NSALLE;
                EXIT;
            END IF;
        ELSE
            IF sal.CAPACITE >= v_taille THEN
                v_salle := sal.NSALLE;
                EXIT;
            END IF;
        END IF;
    END LOOP;
    
    IF v_salle IS NULL 
    THEN
        RAISE_APPLICATION_ERROR(-20303, 'AUCUNE SALLE EST DISPONIBLE');
    END IF;
    RETURN v_salle;
--Exception
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20999, 'ERREUR INATTENDUE ');
END;
/