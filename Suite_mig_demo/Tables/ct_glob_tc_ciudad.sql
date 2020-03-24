CREATE TABLE `ct_glob_tc_ciudad` (
  `id_ciudad` int(11) NOT NULL AUTO_INCREMENT,
  `id_pais` int(11) DEFAULT NULL,
  `clave_ciudad` varchar(4) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_ciudad`),
  KEY `fk_ciudad_pais_idx` (`id_pais`),
  KEY `idx_clave_ciudad` (`clave_ciudad`),
  CONSTRAINT `fk_ciudad_pais` FOREIGN KEY (`id_pais`) REFERENCES `ct_glob_tc_pais` (`id_pais`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8354 DEFAULT CHARSET=utf8;
