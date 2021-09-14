CREATE TABLE `sat_bancos` (
  `id_sat_bancos` int(11) NOT NULL AUTO_INCREMENT,
  `id_pais` int(11) DEFAULT NULL,
  `clave_sat` char(5) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `razon_social` varchar(300) DEFAULT NULL,
  `nacional` varchar(45) DEFAULT NULL,
  `rfc` char(15) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sat_bancos`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;
