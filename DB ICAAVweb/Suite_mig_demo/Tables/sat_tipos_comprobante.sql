CREATE TABLE `sat_tipos_comprobante` (
  `c_TipoDeComprobante` char(1) NOT NULL DEFAULT '',
  `descripcion` varchar(255) DEFAULT NULL,
  `valor_maximo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`c_TipoDeComprobante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
