CREATE TABLE `sat_productos_servicios` (
  `c_ClaveProdServ` char(10) NOT NULL DEFAULT '',
  `descripcion` varchar(255) DEFAULT NULL,
  `fechaInicioVigencia` date DEFAULT NULL,
  `fechaFinVigencia` date DEFAULT NULL,
  `incluirIVAtrasladado` varchar(20) DEFAULT NULL,
  `incluirIEPStrasladado` char(2) DEFAULT NULL,
  `complementoIncluir` varchar(100) DEFAULT NULL,
  `uso_agencia` int(1) DEFAULT NULL,
  PRIMARY KEY (`c_ClaveProdServ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
