CREATE TABLE `ic_glob_tc_cxp_concepto_pago` (
  `id_concepto_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_categoria_concepto` int(11) NOT NULL,
  `descripcion` varchar(155) NOT NULL,
  PRIMARY KEY (`id_concepto_pago`),
  KEY `fk_concepto_pago_categoria_idx` (`id_categoria_concepto`),
  CONSTRAINT `fk_concepto_pago_categoria` FOREIGN KEY (`id_categoria_concepto`) REFERENCES `ic_glob_tc_cxp_categoria_concepto` (`id_categoria_concepto`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=latin1;
