CREATE TABLE `ic_gds_tr_forma_pago` (
  `id_gds_forma_pago` int(11) NOT NULL AUTO_INCREMENT,
  `cve_gds` char(2) DEFAULT NULL,
  `cve_forma_pago_gds` char(2) DEFAULT NULL,
  `desc_forma_pago_gds` varchar(20) DEFAULT NULL,
  `cve_tarjeta_gds` char(2) DEFAULT NULL,
  `desc_tarjeta_gds` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_gds_forma_pago`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
