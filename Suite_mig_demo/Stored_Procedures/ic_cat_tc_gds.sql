CREATE TABLE `ic_cat_tc_gds` (
  `id_gds` int(11) NOT NULL AUTO_INCREMENT,
  `cve_gds` char(2) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_gds`),
  KEY `idx_cve_gds` (`cve_gds`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
