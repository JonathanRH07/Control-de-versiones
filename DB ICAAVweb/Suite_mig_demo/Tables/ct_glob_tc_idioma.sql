CREATE TABLE `ct_glob_tc_idioma` (
  `id_idioma` int(11) NOT NULL AUTO_INCREMENT,
  `cve_idioma` char(3) DEFAULT NULL,
  `idioma` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id_idioma`),
  KEY `idx_cve_idioma` (`cve_idioma`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
