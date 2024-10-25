*******************
--exo4

CREATE TRIGGER tr2  
BEFORE DELETE ON CLIENTS
FOR EACH ROW
BEGIN
    DELETE FROM FACTURES WHERE FACTURES.client_id = OLD.client_id;
END;



**************
--exo5

CREATE TRIGGER CHECK1
BEFORE INSERT OR UPDATE ON Commande
FOR EACH ROW
BEGIN
    IF NEW.date_livraison < NEW.date_commande THEN
       signal sqlstate set message_text="date invalide" ;
    END IF;
END;

--EXO6
**************

CREATE TRIGGER CHECK_SALARY
BEFORE INSERT OR UPDATE ON Employe
FOR EACH ROW
DECLARE
    a NUMBER;
    b NUMBER; 
BEGIN
    IF NEW.job != 'PRESIDENT' THEN
        SELECT fourchette_salaire_min, fourchette_salaire_max INTO a, b
        FROM Grille
        WHERE job = NEW.job;

        IF NEW.salaire NOT BETWEEN a AND b THEN
            signal sqlstate set message="( 'Le salaire doit être dans la fourchette définie pour ce job.')";
        END IF;
    END IF;
END;

--exo7
*****************

CREATE TRIGGER tr1
AFTER INSERT OR UPDATE OR DELETE ON Vente
FOR EACH ROW BEGIN
    UPDATE VolumeAffaire
    SET total = (SELECT SUM(qte * prix) FROM Vente),
        date = SYSDATE;
END;
