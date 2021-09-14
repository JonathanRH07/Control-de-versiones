CREATE TABLE `sat_unidades_medida` (
  `id_unidad` int(11) NOT NULL AUTO_INCREMENT,
  `c_ClaveUnidad` char(3) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fechaInicioVigencia` date DEFAULT NULL,
  `fechaFinVigencia` date DEFAULT NULL,
  `simbolo` char(10) DEFAULT NULL,
  PRIMARY KEY (`id_unidad`)
) ENGINE=MyISAM AUTO_INCREMENT=2419 DEFAULT CHARSET=utf8;
