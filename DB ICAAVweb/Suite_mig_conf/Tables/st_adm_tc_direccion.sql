CREATE TABLE `st_adm_tc_direccion` (
  `id_direccion` int(11) NOT NULL AUTO_INCREMENT,
  `cve_pais` char(3) NOT NULL,
  `calle_direccion` varchar(255) DEFAULT NULL,
  `num_exterior_direccion` varchar(45) DEFAULT NULL,
  `num_interior_direccion` varchar(45) DEFAULT NULL,
  `colonia_direccion` varchar(100) DEFAULT NULL,
  `municipio_direccion` varchar(100) DEFAULT NULL,
  `ciudad_direccion` varchar(100) DEFAULT NULL,
  `estado_direccion` varchar(100) DEFAULT NULL,
  `codigo_postal_direccion` char(10) DEFAULT NULL,
  `estatus_direccion` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod_direccion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_direccion`),
  KEY `idx_cve_pais` (`cve_pais`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
