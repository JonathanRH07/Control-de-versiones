CREATE TABLE `ic_gds_tr_errores` (
  `id_gds_errores` int(11) NOT NULL AUTO_INCREMENT,
  `id_gds_general` int(11) DEFAULT NULL,
  `problema` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_gds_errores`)
) ENGINE=InnoDB AUTO_INCREMENT=2461 DEFAULT CHARSET=utf8;
