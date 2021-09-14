CREATE TABLE `sat_metodo_pago` (
  `c_MetodoPago` char(3) NOT NULL DEFAULT '',
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`c_MetodoPago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
