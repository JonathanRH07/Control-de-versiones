CREATE TABLE `sat_impuestos` (
  `c_Impuesto` char(3) NOT NULL DEFAULT '',
  `descripcion` varchar(255) DEFAULT NULL,
  `retencion` char(2) DEFAULT NULL,
  `traslado` char(2) DEFAULT NULL,
  `local_federal` char(10) DEFAULT NULL,
  `entidadAplica` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`c_Impuesto`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
