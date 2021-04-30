CREATE TABLE `ic_glob_tr_cxp_pago_detalle` (
  `id_cxp_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_pago_anticipo_proveedores` int(11) DEFAULT NULL,
  `id_cxp` int(11) DEFAULT NULL,
  `importe_moneda_base` decimal(13,2) DEFAULT NULL,
  `importe_pago` decimal(13,2) DEFAULT NULL,
  `saldo_act` decimal(13,2) DEFAULT NULL,
  `saldo_ant` decimal(13,2) DEFAULT NULL,
  `no_parcialidad` int(11) DEFAULT NULL,
  `importe_usd` decimal(13,4) DEFAULT NULL,
  `importe_eur` decimal(13,4) DEFAULT NULL,
  `tipo_cambio` decimal(13,4) DEFAULT NULL,
  PRIMARY KEY (`id_cxp_detalle`),
  KEY `fk_cxp_detalle_pago_anticipo_idx` (`id_pago_anticipo_proveedores`),
  KEY `fk_cxp_detalle_cxp_idx` (`id_cxp`),
  CONSTRAINT `fk_cxp_detalle_cxp` FOREIGN KEY (`id_cxp`) REFERENCES `ic_glob_tr_cxp` (`id_cxp`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxp_detalle_pago_anticipo` FOREIGN KEY (`id_pago_anticipo_proveedores`) REFERENCES `ic_glob_tr_cxp_pago_anticipo_proveedores` (`id_pago_anticipo_proveedores`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=latin1;
