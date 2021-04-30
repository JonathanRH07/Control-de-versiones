CREATE TABLE `ic_glob_tc_catalogo` (
  `id_catalogo` int(11) NOT NULL AUTO_INCREMENT,
  `clave` char(10) DEFAULT NULL,
  `nombre_catalogo` char(50) DEFAULT NULL,
  PRIMARY KEY (`id_catalogo`),
  KEY `idx_clave` (`clave`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
