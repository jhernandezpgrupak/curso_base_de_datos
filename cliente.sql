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


-- Volcando estructura de base de datos para curso
DROP DATABASE IF EXISTS `curso`;
CREATE DATABASE IF NOT EXISTS `curso` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `curso`;

-- Volcando estructura para tabla curso.curso_cliente
DROP TABLE IF EXISTS `curso_cliente`;
CREATE TABLE IF NOT EXISTS `curso_cliente` (
  `cliente_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `cliente_razon_social` varchar(60) DEFAULT NULL,
  `cliente_email` varchar(200) NOT NULL DEFAULT '',
  `cliente_estado` char(1) NOT NULL DEFAULT 'A',
  `cliente_documento` int(10) unsigned NOT NULL,
  `fk_pais_id` tinyint(4) NOT NULL,
  `fk_provincia_id` smallint(6) NOT NULL,
  `fk_location_id` mediumint(9) NOT NULL,
  PRIMARY KEY (`cliente_id`),
  UNIQUE KEY `cliente_documento` (`cliente_documento`),
  KEY `fk_pais_id` (`fk_pais_id`,`fk_provincia_id`,`fk_location_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tabla de clientes';

-- La exportación de datos fue deseleccionada.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
