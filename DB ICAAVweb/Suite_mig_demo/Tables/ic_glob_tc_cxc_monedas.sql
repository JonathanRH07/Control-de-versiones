CREATE TABLE `ic_glob_tc_cxc_monedas` (
  `id_cxc_monedas` int(11) NOT NULL AUTO_INCREMENT,
  `id_moneda` int(11) DEFAULT NULL,
  `cantidad` decimal(15,2) DEFAULT NULL,
  `pagos` decimal(15,2) DEFAULT NULL,
  `saldo` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id_cxc_monedas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
