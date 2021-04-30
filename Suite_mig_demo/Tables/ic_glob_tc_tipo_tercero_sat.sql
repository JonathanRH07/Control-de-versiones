CREATE TABLE `ic_glob_tc_tipo_tercero_sat` (
  `id_sat_tipo_tercero` int(11) NOT NULL AUTO_INCREMENT,
  `clave_sat_tipo_tercero` char(2) DEFAULT NULL,
  `origen` char(20) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sat_tipo_tercero`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
