CREATE TABLE `ic_cat_tc_producto` (
  `id_producto` int(11) NOT NULL AUTO_INCREMENT,
  `cve_producto` char(5) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `tipo_empresa` enum('AGENCIA','OTRO') NOT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_producto`),
  KEY `idx_cve_producto` (`cve_producto`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
