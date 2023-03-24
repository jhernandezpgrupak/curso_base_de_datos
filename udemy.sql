-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.24-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.4.0.6659
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para udemy
CREATE DATABASE IF NOT EXISTS `udemy` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `udemy`;

-- Volcando estructura para tabla udemy.alumnos
CREATE TABLE IF NOT EXISTS `alumnos` (
  `alumno_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alumno_nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`alumno_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='Tabla alumnos';

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla udemy.clientes
CREATE TABLE IF NOT EXISTS `clientes` (
  `Cli_Id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Id de Cliente',
  `Cli_RazonSocial` varchar(80) NOT NULL DEFAULT '' COMMENT 'Nombre de Cliente',
  PRIMARY KEY (`Cli_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2419 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento udemy.CodigosABC
DELIMITER //
CREATE PROCEDURE `CodigosABC`(
	IN `fecha_desde` DATE,
	IN `fecha_hasta` DATE
)
    READS SQL DATA
BEGIN
	DECLARE ganancia DECIMAL(10,2);
	DECLARE gananciaA DECIMAL(10,2);
	DECLARE gananciaB DECIMAL(10,2);
	DECLARE gananciaC DECIMAL(10,2);	
	
	DECLARE id INT;
	DECLARE utilidad DECIMAL(10,2);
	DECLARE acomulado DECIMAL(10,2);
	DECLARE letra CHAR(01);
	DECLARE final TINYINT DEFAULT 0;
	
	DECLARE cur_uti CURSOR FOR 
		SELECT VD_ProdID, SUM(VD_Cantidad *(VD_Precio - VD_Costo)) AS _utilidad
			FROM ventas_detalle 
			JOIN ventas ON VD_VentasID = Ventas_ID
		WHERE Ventas_Fecha BETWEEN fecha_desde AND fecha_hasta
		AND VD_Costo > 0 AND VD_Precio>VD_Costo
		GROUP BY VD_ProdID
		ORDER BY _utilidad DESC; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET final = 1;
	
	#Obtengo la utilidad de la siguiente funcion 
	SELECT UtilidadTotal(fecha_desde, fecha_hasta) INTO ganancia;
	
	#Seteo las varibale dependiodo de su porcentaje
	SET gananciaA = ganancia * .80;
	SET gananciaB = ganancia * .15;
	SET gananciaC = ganancia * .05;
	SET letra = 'C';
	SET acomulado = 0;
	
	OPEN cur_uti;
	
	WHILE final = 0 DO

		FETCH cur_uti INTO id, utilidad;
		IF final = 0 THEN
			SET acomulado = acomulado + utilidad;
		
			IF letra = 'C' AND acomulado > gananciaC THEN 
				SET acomulado = utilidad;
				SET letra = 'B';
			END IF;
			
			IF letra = 'B' AND acomulado > gananciaB THEN 
				SET acomulado = utilidad;
				SET letra = 'A';
			END IF;		
			
			UPDATE productos SET Prod_ABC = letra WHERE Prod_Id = id;
			
		END IF;
		
	END WHILE;
	
	CLOSE cur_uti;
	
END//
DELIMITER ;

-- Volcando estructura para función udemy.GananciaVentas
DELIMITER //
CREATE FUNCTION `GananciaVentas`(`_ano` INT,
	`_mes` INT
) RETURNS decimal(10,2)
    READS SQL DATA
    COMMENT 'Ganancia de ventas'
BEGIN
	DECLARE ganancia DECIMAL (10,2);
	DECLARE precio DECIMAL(10,2);
	DECLARE cantidad MEDIUMINT;
	DECLARE costo DECIMAL(10,2);
	DECLARE final TINYINT DEFAULT 0;
	
	DECLARE cv CURSOR FOR
		SELECT VD_Precio, VD_Costo, VD_Cantidad
			FROM ventas_detalle 
			JOIN ventas ON VD_VentasID=Ventas_ID
		WHERE VD_Costo>0 AND YEAR(Ventas_Fecha) = _ano
		AND MONTH(Ventas_Fecha) = _mes;
	#Manejador de fin de archivo
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET final=1;
	
	SET Ganancia = 0;
	#Abrir el cursor...
	OPEN cv;
	#Recorrer el cursor
	WHILE final = 0 DO
		FETCH cv INTO precio, costo, cantidad;
		IF final = 0 THEN
			SET ganancia = ganancia + ((precio - costo) * cantidad);
		END IF;
	END WHILE;
	
	CLOSE cv;
	RETURN ganancia; 
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento udemy.InsertaAlumno
DELIMITER //
CREATE PROCEDURE `InsertaAlumno`(
	IN `id` INT,
	IN `nombre` VARCHAR(50)
)
    COMMENT 'Insertar Alumno'
BEGIN
	#Cuando se detecta que existe una clave duplicada
	DECLARE CONTINUE handler FOR 1062 SELECT "Clave duplicada" AS Advertencia;
	INSERT INTO alumnos (alumno_id, alumno_nombre) VALUES(id,nombre);
END//
DELIMITER ;

-- Volcando estructura para vista udemy.listaproductos
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `listaproductos` (
	`Prod_Id` MEDIUMINT(8) UNSIGNED NOT NULL COMMENT 'Id de Producto, Numero generado Automaticamente ante cada INSERT',
	`Prod_Descripcion` VARCHAR(80) NOT NULL COMMENT 'Descripción del Producto' COLLATE 'utf8_general_ci',
	`Prod_Color` VARCHAR(20) NOT NULL COMMENT 'Color del Producto' COLLATE 'utf8_general_ci',
	`Prod_Status` TINYINT(1) UNSIGNED NOT NULL COMMENT 'Estado del Producto 1=Habilitado, 0=Deshabilitado',
	`Prod_Precio` DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Precio del Producto',
	`Prod_ProvId` INT(11) NULL COMMENT 'Id del Proveedor de ese Producto',
	`Prod_ABC` CHAR(1) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- Volcando estructura para procedimiento udemy.MaximaVenta
DELIMITER //
CREATE PROCEDURE `MaximaVenta`()
    COMMENT 'Seleccionar el maximo de ventas'
BEGIN
	DECLARE valor_maximo DECIMAL(10,2);
	SET valor_maximo = 0;
	
	SELECT MAX(Ventas_Total) INTO valor_maximo FROM ventas;
	IF valor_maximo > 1000 then
		SELECT 'Se han superado los $1000' AS Mensaje;
	else
		SELECT 'Aun no superamos los $1000' AS Mensaje;
	END IF;	
END//
DELIMITER ;

-- Volcando estructura para tabla udemy.productos
CREATE TABLE IF NOT EXISTS `productos` (
  `Prod_Id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Id de Producto, Numero generado Automaticamente ante cada INSERT',
  `Prod_Descripcion` varchar(80) NOT NULL DEFAULT '' COMMENT 'Descripción del Producto',
  `Prod_Color` varchar(20) NOT NULL DEFAULT '' COMMENT 'Color del Producto',
  `Prod_Status` tinyint(1) unsigned NOT NULL DEFAULT 1 COMMENT 'Estado del Producto 1=Habilitado, 0=Deshabilitado',
  `Prod_Precio` decimal(10,2) unsigned NOT NULL DEFAULT 0.00 COMMENT 'Precio del Producto',
  `Prod_ProvId` int(11) DEFAULT 0 COMMENT 'Id del Proveedor de ese Producto',
  `Prod_ABC` char(1) DEFAULT NULL,
  PRIMARY KEY (`Prod_Id`),
  KEY `Prod_ProvId` (`Prod_ProvId`)
) ENGINE=InnoDB AUTO_INCREMENT=6990 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para vista udemy.productosproveedor
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `productosproveedor` (
	`Prod_Id` MEDIUMINT(8) UNSIGNED NOT NULL COMMENT 'Id de Producto, Numero generado Automaticamente ante cada INSERT',
	`Prod_Descripcion` VARCHAR(80) NOT NULL COMMENT 'Descripción del Producto' COLLATE 'utf8_general_ci',
	`Prod_Color` VARCHAR(20) NOT NULL COMMENT 'Color del Producto' COLLATE 'utf8_general_ci',
	`Prod_Status` TINYINT(1) UNSIGNED NOT NULL COMMENT 'Estado del Producto 1=Habilitado, 0=Deshabilitado',
	`Prod_Precio` DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Precio del Producto',
	`Prod_ProvId` INT(11) NULL COMMENT 'Id del Proveedor de ese Producto',
	`Prod_ABC` CHAR(1) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- Volcando estructura para tabla udemy.productos_historial
CREATE TABLE IF NOT EXISTS `productos_historial` (
  `PH_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `PH_ProdId` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `PH_PrecioAnt` decimal(10,2) unsigned NOT NULL DEFAULT 0.00,
  `PH_PrecioNew` decimal(10,2) unsigned NOT NULL DEFAULT 0.00,
  `PH_Fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `PH_Usuario` varchar(100) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PH_id`),
  KEY `PH_ProdId` (`PH_ProdId`),
  KEY `PH_Fecha` (`PH_Fecha`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla udemy.proveedores
CREATE TABLE IF NOT EXISTS `proveedores` (
  `Prov_Id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `Prov_Nombre` varchar(60) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Prov_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para función udemy.ProveedorID
DELIMITER //
CREATE FUNCTION `ProveedorID`() RETURNS mediumint(9)
    NO SQL
    DETERMINISTIC
BEGIN
	#Prametro intriseco
	RETURN @ParamProvID;
END//
DELIMITER ;

-- Volcando estructura para función udemy.UtilidadTotal
DELIMITER //
CREATE FUNCTION `UtilidadTotal`(`fecha_desde` DATE,
	`fecha_hasta` DATE
) RETURNS decimal(10,2)
    READS SQL DATA
BEGIN
	DECLARE ganancia DECIMAL(10,2);
	
	SELECT SUM(VD_Cantidad*(VD_Precio - VD_Costo)) INTO ganancia 
	FROM Ventas_Detalle 
		INNER JOIN Ventas ON Ventas_Id = VD_VentasId
	WHERE Ventas_Fecha BETWEEN fecha_desde AND fecha_hasta
	AND VD_Costo > 0 AND VD_Precio > VD_Costo;
	
	RETURN ganancia;
END//
DELIMITER ;

-- Volcando estructura para tabla udemy.ventas
CREATE TABLE IF NOT EXISTS `ventas` (
  `Ventas_Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Ventas_Fecha` date NOT NULL,
  `Ventas_CliId` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `Ventas_NroFactura` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `Ventas_Neto` decimal(10,2) unsigned NOT NULL DEFAULT 0.00,
  `Ventas_Iva` decimal(10,2) unsigned NOT NULL DEFAULT 0.00,
  `Ventas_Total` decimal(10,2) unsigned NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`Ventas_Id`),
  KEY `Ventas_CliId` (`Ventas_CliId`)
) ENGINE=InnoDB AUTO_INCREMENT=139974 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla udemy.ventas_detalle
CREATE TABLE IF NOT EXISTS `ventas_detalle` (
  `VD_Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `VD_VentasId` bigint(20) unsigned NOT NULL DEFAULT 0,
  `VD_ProdId` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `VD_Cantidad` mediumint(8) unsigned NOT NULL DEFAULT 0,
  `VD_Precio` decimal(10,2) unsigned NOT NULL DEFAULT 0.00,
  `VD_Costo` decimal(10,2) unsigned NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`VD_Id`),
  KEY `VD_VentasId` (`VD_VentasId`),
  KEY `VD_ProdId` (`VD_ProdId`)
) ENGINE=InnoDB AUTO_INCREMENT=55013 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para disparador udemy.nombre_mayusculas
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `nombre_mayusculas` BEFORE INSERT ON `alumnos` FOR EACH ROW BEGIN
	SET NEW.alumno_nombre = UCASE(NEW.alumno_nombre);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador udemy.productos_after_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `productos_after_update` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
	IF NEW.Prod_Precio <> OLD.Prod_Precio THEN
		INSERT INTO productos_historial 
			(PH_ProdID, 
				PH_PrecioAnt, 
				PH_PrecioNew,
				PH_Usuario
			)
			VALUES(NEW.Prod_Id, 
				OLD.Prod_Precio, 
				NEW.Prod_Precio, 
				CURRENT_USER
			);			
	END IF; 	
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para vista udemy.listaproductos
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `listaproductos`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `listaproductos` AS SELECT *FROM Productos ;

-- Volcando estructura para vista udemy.productosproveedor
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `productosproveedor`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `productosproveedor` AS SELECT *FROM Productos WHERE (Prod_ProvId = ProveedorID()) ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
