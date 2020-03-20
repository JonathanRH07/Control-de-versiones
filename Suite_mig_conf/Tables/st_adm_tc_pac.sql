CREATE TABLE `st_adm_tc_pac` (
  `id_pac` int(11) NOT NULL AUTO_INCREMENT,
  `cve_pac` char(3) DEFAULT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `url_timbrado` varchar(500) DEFAULT NULL,
  `url_timbrado_produccion` varchar(500) DEFAULT NULL,
  `rfc_pac` varchar(15) DEFAULT NULL,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_pac`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
