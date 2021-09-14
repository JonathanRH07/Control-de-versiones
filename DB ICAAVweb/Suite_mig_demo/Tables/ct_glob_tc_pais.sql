CREATE TABLE `ct_glob_tc_pais` (
  `id_pais` int(11) NOT NULL AUTO_INCREMENT,
  `pais` varchar(100) DEFAULT NULL,
  `alt_pais` varchar(100) DEFAULT NULL,
  `cve_pais` char(3) DEFAULT NULL,
  `cve_pais_SAT` varchar(3) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pais`),
  KEY `idx_cve_pais` (`cve_pais`),
  KEY `idx_estatus` (`estatus`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8;
