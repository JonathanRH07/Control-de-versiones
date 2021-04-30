CREATE TABLE `ic_fac_tr_factura_forma_pago` (
  `id_factura_forma_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL COMMENT 'Cambiar por id_forma_pago',
  `id_antcte` int(11) DEFAULT NULL,
  `id_forma_pago_sat` char(2) DEFAULT NULL,
  `importe` decimal(15,2) DEFAULT NULL,
  `referencia_anticipo` varchar(20) DEFAULT NULL,
  `concepto` varchar(50) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_factura_forma_pago`),
  KEY `fk_forma_pago_usuario_idx` (`id_usuario`),
  KEY `fk_forma_pago_factura_idx` (`id_factura`),
  CONSTRAINT `fk_forma_pago_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_forma_pago_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5925 DEFAULT CHARSET=utf8;
