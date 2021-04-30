CREATE TABLE `sat_formas_pago` (
  `c_FormaPago` char(2) NOT NULL DEFAULT '',
  `descripcion` varchar(255) DEFAULT NULL,
  `bancarizado` varchar(8) DEFAULT NULL,
  `numeroOperacion` varchar(8) DEFAULT NULL,
  `RFCEmisorOrdenante` varchar(8) DEFAULT NULL,
  `cuentaOrdenante` varchar(8) DEFAULT NULL,
  `patronCuentaOrdenante` varchar(100) DEFAULT NULL,
  `rfc_emi_cta_benef` varchar(25) DEFAULT NULL,
  `cta_benenficiario` varchar(25) DEFAULT NULL,
  `patron_cta_benef` varchar(50) DEFAULT NULL,
  `tipoCadenaPago` varchar(8) DEFAULT NULL,
  `bancoEmiCtaOrdenanteExt` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`c_FormaPago`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
