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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='Tabla alumnos';

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla udemy.clientes
CREATE TABLE IF NOT EXISTS `clientes` (
  `Cli_Id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Id de Cliente',
  `Cli_RazonSocial` varchar(80) NOT NULL DEFAULT '' COMMENT 'Nombre de Cliente',
  PRIMARY KEY (`Cli_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2419 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

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
  PRIMARY KEY (`Prod_Id`),
  KEY `Prod_ProvId` (`Prod_ProvId`)
) ENGINE=InnoDB AUTO_INCREMENT=6990 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla udemy.proveedores
CREATE TABLE IF NOT EXISTS `proveedores` (
  `Prov_Id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `Prov_Nombre` varchar(60) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Prov_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

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

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
