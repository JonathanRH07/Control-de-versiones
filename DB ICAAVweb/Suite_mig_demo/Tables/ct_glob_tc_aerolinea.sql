CREATE TABLE `ct_glob_tc_aerolinea` (
  `id_aerolinea` int(11) NOT NULL AUTO_INCREMENT,
  `clave_aerolinea` char(3) DEFAULT NULL,
  `codigo_bsp` char(3) DEFAULT NULL,
  `nombre_aerolinea` varchar(255) DEFAULT NULL,
  `pais` varchar(45) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_aerolinea`),
  KEY `idx_codigo_bsp` (`codigo_bsp`) USING BTREE,
  KEY `dix_estatus` (`estatus`) USING BTREE,
  KEY `idx_clave_aerolinea` (`clave_aerolinea`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=591 DEFAULT CHARSET=utf8;
