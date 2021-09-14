CREATE TABLE `ct_glob_tc_moneda` (
  `id_moneda` int(11) NOT NULL AUTO_INCREMENT,
  `clave_moneda` varchar(10) DEFAULT NULL,
  `signo` char(5) DEFAULT NULL,
  `decripcion` varchar(100) DEFAULT NULL,
  `decimales` tinyint(1) DEFAULT NULL,
  `porc_variacion` char(10) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_moneda`),
  KEY `idx_clave_moneda` (`clave_moneda`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8;
