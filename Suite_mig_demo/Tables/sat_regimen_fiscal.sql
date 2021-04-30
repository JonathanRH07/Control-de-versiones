CREATE TABLE `sat_regimen_fiscal` (
  `c_RegimenFiscal` int(11) NOT NULL DEFAULT '0',
  `descripcion` varchar(255) DEFAULT NULL,
  `aplica_fisica` char(2) DEFAULT NULL,
  `aplica_moral` char(2) DEFAULT NULL,
  PRIMARY KEY (`c_RegimenFiscal`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
