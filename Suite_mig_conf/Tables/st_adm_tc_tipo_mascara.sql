CREATE TABLE `st_adm_tc_tipo_mascara` (
  `id_tipo_mascara` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_mascara` varchar(45) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_mascara`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
