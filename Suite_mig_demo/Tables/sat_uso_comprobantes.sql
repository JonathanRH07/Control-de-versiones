CREATE TABLE `sat_uso_comprobantes` (
  `c_UsoCFDI` char(3) NOT NULL DEFAULT '',
  `descripcion` varchar(255) DEFAULT NULL,
  `aplica_fisica` char(2) DEFAULT NULL,
  `aplica_moral` char(2) DEFAULT NULL,
  PRIMARY KEY (`c_UsoCFDI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
