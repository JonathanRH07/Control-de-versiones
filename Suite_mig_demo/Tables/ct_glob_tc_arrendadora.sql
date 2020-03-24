CREATE TABLE `ct_glob_tc_arrendadora` (
  `id_arrendadora` int(11) NOT NULL AUTO_INCREMENT,
  `cve_arrendadora` varchar(2) DEFAULT NULL,
  `id_ciudad` int(11) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `nombre_comercial` varchar(100) DEFAULT NULL,
  `razon_social` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_arrendadora`),
  KEY `idx_clave_arrendadora` (`cve_arrendadora`) USING BTREE,
  KEY `fk_arrendadora_ciudad_idx` (`id_ciudad`) USING BTREE,
  KEY `idx_estatus` (`estatus`),
  CONSTRAINT `fk_arrendadora_ciudad` FOREIGN KEY (`id_ciudad`) REFERENCES `ct_glob_tc_ciudad` (`id_ciudad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=87254 DEFAULT CHARSET=utf8;
