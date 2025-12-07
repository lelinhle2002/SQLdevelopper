CREATE OR REPLACE PACKAGE CELCAT
AS
    TYPE T_SALLES_DISPO IS TABLE OF SALLE.NSALLE%TYPE INDEX BY PLS_INTEGER;
    FUNCTION GET_SALLES_DISP
    (
        P_DEBSEMC IN CRENEAU.DEBSEMC%TYPE,
        P_JOURC   IN CRENEAU.JOURC%TYPE,
        P_HEUREDC IN CRENEAU.HEUREDC%TYPE,
        P_GRPC    IN CRENEAU.GRPC%TYPE,
        P_TYPEC   IN CRENEAU.TYPEC%TYPE
    )RETURN T_SALLES_DISPO;
END CELCAT;
/
CREATE OR REPLACE PACKAGE BODY CELCAT AS
    FUNCTION GET_SALLES_DISP 
        (P_DEBSEMC IN CRENEAU.DEBSEMC%TYPE,
        P_JOURC   IN CRENEAU.JOURC%TYPE,
        P_HEUREDC IN CRENEAU.HEUREDC%TYPE,
        P_GRPC    IN CRENEAU.GRPC%TYPE,
        P_TYPEC   IN CRENEAU.TYPEC%TYPE) 
RETURN T_SALLES_DISPO
IS
    CURSOR c_salle IS
        SELECT NSALLE, TSAL, CAPACITE
        FROM SALLE
        WHERE NSALLE NOT IN 
        (
            SELECT NSALLE
            FROM AFFECTER 
            WHERE DEBSEMC = P_DEBSEMC
            AND JOURC = P_JOURC
            AND (P_HEUREDC >= HEUREDC)
        );
     RES T_SALLES_DISPO := T_SALLES_DISPO();
     v_taille_grp GROUPE.EFF%TYPE;
     v_nsalle SALLE.NSALLE%TYPE;
     v_capacite SALLE.CAPACITE%TYPE;
     v_tsal SALLE.TSAL%TYPE;
     v_grpcExist NUMBER;
     i PLS_INTEGER :=0;
     v_heure DATE;
     INCORRECT_HOUR_FORMAT EXCEPTION;
     PRAGMA EXCEPTION_INIT(INCORRECT_HOUR_FORMAT,-1861);
BEGIN
    IF (P_DEBSEMC IS NULL AND
        P_JOURC   IS NULL AND
        P_HEUREDC IS NULL AND
        P_GRPC    IS NULL AND
        P_TYPEC IS NULL)
    THEN
        RAISE_APPLICATION_ERROR(-20104, 'Tous les parametres doivent etre renseignes.');
    END IF;

    --IF LENGTH(P_HEUREDC) != 5 OR SUBSTR(P_HEUREDC,3,1) != ':'
    --THEN
    --    RAISE_APPLICATION_ERROR(-20102, 'Le format de l''heure de debut ou de fin doit etre HH:MM');
    --END IF;

    v_heure := TO_DATE(P_HEUREDC, 'HH24:MI');

    SELECT EFF
    INTO v_taille_grp
    FROM GROUPE
    WHERE upper(GRPC) = upper(P_GRPC);

    FOR salle_rec IN c_salle LOOP
        v_nsalle := salle_rec.NSALLE;
        v_capacite := salle_rec.CAPACITE;
        v_tsal := salle_rec.TSAL;
        IF (v_capacite >= v_taille_grp) AND (v_tsal ='TP' OR P_TYPEC<>'TP')
        THEN    
            --RES.EXTEND;
            --RES(RES.COUNT):= v_nsalle;
            i:=i+1;
            RES(i) := v_nsalle;
        END IF;
    END LOOP;
    RETURN RES;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
        RAISE_APPLICATION_ERROR(-20105,'Le groupe '||P_GRPC||' n''existe pas.'); 
    WHEN INCORRECT_HOUR_FORMAT
    THEN
        RAISE_APPLICATION_ERROR(-20102, 'Le format de l''heure de debut ou de fin doit etre HH:MM');
END GET_SALLES_DISP;
END CELCAT;
/