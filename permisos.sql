DELIMITER $$

USE `enfoque_cliente`$$

DROP PROCEDURE IF EXISTS `permisos`$$

CREATE DEFINER=`enfoquecliente`@`%` PROCEDURE `permisos`(IN tipo_cliente INT)
BEGIN
    
	DECLARE id INT;
	DECLARE final TINYINT DEFAULT 0;
	DECLARE cur_sor CURSOR FOR 
		SELECT 
		  usuario_id 
		FROM
		  ec_usuario 
		  INNER JOIN ec_cliente 
		    ON fk_cliente_id = cliente_id 
		WHERE fk_tipo_cliente_id = tipo_cliente
		AND usuario_id <> 1 #Sistemas 
		ORDER BY usuario_id ASC; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET final = 1;
	
	OPEN cur_sor;
		WHILE final = 0 DO
			FETCH cur_sor INTO id;
				IF final = 0 THEN
					INSERT INTO ec_permiso (permiso_orden, fk_menu_id, fk_usuario_id)
						VALUES(1,1,id);
					INSERT INTO ec_permiso (permiso_orden, fk_menu_id, fk_usuario_id)
						VALUES(2,2,id);
					INSERT INTO ec_permiso (permiso_orden, fk_menu_id, fk_usuario_id)
						VALUES(3,5,id);
					INSERT INTO ec_permiso (permiso_orden, fk_menu_id, fk_usuario_id)
						VALUES(4,6,id);
					INSERT INTO ec_permiso (permiso_orden, fk_menu_id, fk_usuario_id)
						VALUES(5,3,id);
					INSERT INTO ec_permiso (permiso_orden, fk_menu_id, fk_usuario_id)
						VALUES(6,4,id);						
				END IF;
		END WHILE;
	CLOSE cur_sor;																		
    END$$

DELIMITER ;