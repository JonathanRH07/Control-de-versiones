CREATE TABLE `ic_fac_tr_factura_centro_costo` (
  `id_factura_centro_costo` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura` int(11) NOT NULL,
  `id_centro_costo` int(11) NOT NULL,
  `nivel` smallint(1) DEFAULT NULL,
  `clave` varchar(45) DEFAULT NULL,
  `fecha_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_factura_centro_costo`),
  KEY `fk_centro_costo_factura_idx` (`id_factura`),
  KEY `fk_centro_costo_factura_centro_costo_idx` (`id_centro_costo`),
  KEY `idx_centro_costo_factura` (`nivel`) USING BTREE,
  CONSTRAINT `fk_centro_costo_factura` FOREIGN KEY (`id_factura`) REFERENCES `ic_fac_tr_factura` (`id_factura`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_centro_costo_factura_centro_costo` FOREIGN KEY (`id_centro_costo`) REFERENCES `ic_cat_tr_centro_costo` (`id_centro_costo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=269 DEFAULT CHARSET=latin1;
