CREATE TABLE `ic_glob_tr_cxp_pago_anticipos` (
  `id_cxp_pago_anticipos` int(11) NOT NULL AUTO_INCREMENT,
  `id_pago_anticipo_proveedores` int(11) NOT NULL,
  `id_anticipo` int(11) NOT NULL,
  PRIMARY KEY (`id_cxp_pago_anticipos`),
  KEY `fk_cxp_pago_anticipos_pago_proveedores_idx` (`id_pago_anticipo_proveedores`),
  KEY `fk_cxp_pago_anticipo_idx` (`id_anticipo`),
  CONSTRAINT `fk_cxp_pago_anticipo` FOREIGN KEY (`id_anticipo`) REFERENCES `ic_glob_tr_cxp_pago_anticipo_proveedores` (`id_pago_anticipo_proveedores`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxp_pago_anticipos_pago_proveedores` FOREIGN KEY (`id_pago_anticipo_proveedores`) REFERENCES `ic_glob_tr_cxp_pago_anticipo_proveedores` (`id_pago_anticipo_proveedores`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
