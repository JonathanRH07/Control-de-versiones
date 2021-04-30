CREATE TABLE `ic_glob_tc_tipo_cambio` (
  `id_tipo_cambio` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_cambio` date DEFAULT NULL,
  `USD` decimal(15,4) DEFAULT NULL,
  `EUR` decimal(15,4) DEFAULT NULL,
  `CAD` decimal(15,4) DEFAULT NULL,
  `GBP` decimal(15,4) DEFAULT NULL,
  `ARS` decimal(15,4) DEFAULT NULL,
  `fecha_modifica` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_cambio`)
) ENGINE=InnoDB AUTO_INCREMENT=683 DEFAULT CHARSET=utf8;
