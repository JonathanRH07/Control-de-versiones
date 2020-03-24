CREATE TABLE `ct_glob_tc_pac` (
  `id_pac` int(11) NOT NULL AUTO_INCREMENT,
  `cve_pac` char(3) DEFAULT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `url_timbrado` varchar(500) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_pac`),
  KEY `idx_cve_pac` (`cve_pac`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
