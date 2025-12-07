create or replace PROCEDURE INS_CRENEAU 
(P_DEBSEMC IN CRENEAU.DEBSEMC%TYPE,
P_JOURC IN CRENEAU.JOURC%TYPE, 
P_HEUREDC IN CRENEAU.HEUREDC%TYPE, 
P_GRPC IN CRENEAU.GRPC%TYPE, 
P_TYPEC IN CRENEAU.TYPEC%TYPE, 
P_HEUREFC IN CRENEAU.HEUREFC%TYPE, 
P_NOME IN ENSEIGNANT.NOM%TYPE, 
P_PRENOME IN ENSEIGNANT.PRENOM%TYPE, 
P_IDENS IN ENSEIGNANT.IDENSEIGN%TYPE, 
P_MATC IN CRENEAU.MATC%TYPE) AS
    v_salle_disp VARCHAR2(10);
    v_idens ENSEIGNANT.IDENSEIGN%TYPE;
    v_ExistMat NUMBER;
BEGIN
    IF (P_DEBSEMC IS NULL OR P_JOURC IS NULL OR P_HEUREDC IS NULL OR P_GRPC IS NULL OR P_TYPEC IS NULL OR P_HEUREFC IS NULL OR P_MATC IS NULL)
    THEN
        RAISE_APPLICATION_ERROR(-20107, 'Les parametres P_DEBSEMC, P_JOURC, P_HEUREDC, P_GRPC, P_TYPEC, P_HEUREFC et P_MATC doivent etre renseignes');
    END IF;

    IF (P_IDENS IS NOT NULL AND P_NOME IS NOT NULL) OR (P_IDENS IS NULL AND P_NOME IS NULL)
    THEN
        RAISE_APPLICATION_ERROR(-20108, 'P_IDENS ou P_NOME doit etre renseigne, mais pas les deux.');
    END IF;

    IF (P_PRENOME IS NOT NULL AND P_NOME IS NULL)
    THEN
        RAISE_APPLICATION_ERROR(-20108, 'P_PRENOME ne peut être renseigne que si le P_NOME l''est aussi');
    END IF;

    IF (P_IDENS IS NULL)
    THEN
        v_idens := GET_ENSEIGNANT(P_NOME, P_PRENOME);
    ELSE
        v_idens := P_IDENS;
    END IF;
    
    DECLARE
    v_check NUMBER;
    BEGIN
    SELECT COUNT(*) INTO v_check
    FROM ENSEIGNANT
    WHERE IDENSEIGN = v_idens;

    IF v_check = 0 THEN
        RAISE_APPLICATION_ERROR(-20109, 'L''identifiant de l''enseignant n''existe pas.');
    END IF;
    END;

    v_salle_disp := GET_SALLE_DISP(P_DEBSEMC,P_JOURC, P_HEUREDC, P_GRPC,P_TYPEC);
    IF v_salle_disp IS NULL
    THEN
        RAISE_APPLICATION_ERROR(-20106,'Pas de salle de disponible pour ce creneau.');
    END IF;

    IF (P_HEUREDC >= P_HEUREFC)
    THEN
        RAISE_APPLICATION_ERROR(-20111, 'L''heure de debut doit etre anterieure a l''heure de fin.');
    END IF;

    SELECT COUNT(*) INTO v_ExistMat FROM CRENEAU C WHERE C.MATC = P_MATC;
    IF v_ExistMat = 0 
    THEN 
        RAISE_APPLICATION_ERROR(-20110,  'L''identifiant de la matiere n''existe pas.');
    END IF;

    DECLARE
    BEGIN
    INSERT INTO CRENEAU VALUES
        (P_DEBSEMC, P_JOURC, P_HEUREDC,  P_TYPEC , P_HEUREFC, P_GRPC, P_MATC);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Le créneau existe déjà.');
    END;

    DECLARE 
    BEGIN
        INSERT INTO ENSEIGNER VALUES
        (P_DEBSEMC, P_JOURC, P_HEUREDC,  P_GRPC, v_idens);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('L''enseignant est déjà affecté à ce créneau.');
    END;

    INSERT INTO AFFECTER VALUES
        (P_DEBSEMC, P_JOURC, P_HEUREDC,  P_GRPC, v_salle_disp);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Cette salle est déjà affectée à ce créneau.');
END INS_CRENEAU;
