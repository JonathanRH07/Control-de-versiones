CREATE TABLE `ic_glob_tc_tipo_ope_sat` (
  `id_sat_tipo_operacion` int(11) NOT NULL AUTO_INCREMENT,
  `cve_sat_tipo_ope` char(2) DEFAULT NULL,
  `origen` varchar(50) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sat_tipo_operacion`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
