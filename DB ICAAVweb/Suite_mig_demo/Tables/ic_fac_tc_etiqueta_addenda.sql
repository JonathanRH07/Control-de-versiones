CREATE TABLE `ic_fac_tc_etiqueta_addenda` (
  `id_etiqueta_addenda` int(11) NOT NULL AUTO_INCREMENT,
  `etiqueta_addenda` varchar(100) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `tipo_etiqueta` varchar(10) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_etiqueta_addenda`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
