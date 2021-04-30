CREATE TABLE `ic_cat_tr_impuesto_contable` (
  `id_impuesto_contable` int(11) NOT NULL AUTO_INCREMENT,
  `id_impuesto` int(11) NOT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `id_cuenta_contable` int(11) DEFAULT NULL,
  `id_cuenta_contable_x_trans` int(11) DEFAULT NULL,
  `id_cuenta_contable_ingreso` int(11) DEFAULT NULL,
  `por_trasladar` char(1) DEFAULT NULL,
  `cuenta_ingreso_porcentaje` decimal(2,2) DEFAULT NULL,
  PRIMARY KEY (`id_impuesto_contable`),
  KEY `fk_impuesto_contable_impuesto_idx` (`id_impuesto`),
  KEY `fk_impuesto_contrable_sucursal_idx` (`id_sucursal`),
  KEY `fk_impuesto_contable_cuenta_idx` (`id_cuenta_contable`),
  CONSTRAINT `fk_impuesto_contable_cuenta` FOREIGN KEY (`id_cuenta_contable`) REFERENCES `ic_cat_tc_cuenta_contable` (`id_cuenta_contable`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_impuesto_contable_impuesto` FOREIGN KEY (`id_impuesto`) REFERENCES `ic_cat_tr_impuesto` (`id_impuesto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_impuesto_contrable_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
