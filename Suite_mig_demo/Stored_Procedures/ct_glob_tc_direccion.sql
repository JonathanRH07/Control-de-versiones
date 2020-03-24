CREATE TABLE `ct_glob_tc_direccion` (
  `id_direccion` int(11) NOT NULL AUTO_INCREMENT,
  `cve_pais` char(2) DEFAULT NULL,
  `calle` varchar(255) DEFAULT NULL,
  `num_exterior` varchar(45) DEFAULT NULL,
  `num_interior` varchar(45) DEFAULT NULL,
  `colonia` varchar(100) DEFAULT NULL,
  `municipio` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `estado` varchar(100) DEFAULT NULL,
  `codigo_postal` char(10) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_direccion`),
  KEY `cve_pais` (`cve_pais`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29674 DEFAULT CHARSET=utf8;
