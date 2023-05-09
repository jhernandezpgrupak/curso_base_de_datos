DELIMITER $$

USE `enfoque_cliente`$$

DROP PROCEDURE IF EXISTS `precio_lamina`$$

CREATE DEFINER=`enfoquecliente`@`%` PROCEDURE `precio_lamina`()
BEGIN
    
	####
	DECLARE final TINYINT DEFAULT 0;#Nos funciona como bandera
	DECLARE id INT; #Primer variable a guardar 
	DECLARE sap INT;#Segund variable a guardar
	DECLARE cur_sor CURSOR FOR#Declarar cursor
		SELECT 
		  temporal_id,
		  temporal_sap 
		FROM
		  ec_temporal 
		WHERE temporal_id IN
		  (SELECT 
		    fk_cliente_id 
		  FROM
		    ec_precio_lamina)
		AND temporal_id > 0 
		AND temporal_sap IS NOT NULL;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET final = 1;#Setear la bandera para terminar el bucle    
	###
	OPEN cur_sor;#Abrir el cursor	
		WHILE final = 0 DO
			FETCH cur_sor INTO id,sap;
			IF final = 0 THEN
				UPDATE ec_precio_lamina 
					SET pl_sap = sap
					WHERE fk_cliente_id = id;
			END IF;
		END WHILE;
	CLOSE cur_sor;
    END$$

DELIMITER ;