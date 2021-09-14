CREATE TABLE `ic_cat_tr_meta_venta_tipo` (
  `id_meta_venta_tipo` int(11) NOT NULL AUTO_INCREMENT,
  `id_meta_venta` int(11) NOT NULL,
  `id_vendedor` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `id_empresa` int(11) DEFAULT NULL,
  `total` decimal(15,2) DEFAULT NULL,
  `id_usuario` varchar(45) NOT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_meta_venta_tipo`),
  KEY `fk_ic_cat_tr_meta_venta_tipo_ic_cat_tr_sucursal_idx` (`id_sucursal`) USING BTREE,
  KEY `fk_ic_cat_tr_meta_venta_tipo_ic_cat_tr_meta_venta_idx` (`id_meta_venta`) USING BTREE,
  KEY `fk_ic_cat_tr_meta_venta_tipo_ic_cat_tr_vendedor_idx` (`id_vendedor`) USING BTREE,
  KEY `fk_ic_cat_tr_meta_venta_tipo_st_adm_tr_empresa_idx` (`id_empresa`) USING BTREE,
  CONSTRAINT `fk_ic_cat_tr_meta_venta_tipo_ic_cat_tr_meta_venta` FOREIGN KEY (`id_meta_venta`) REFERENCES `ic_cat_tr_meta_venta` (`id_meta_venta`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ic_cat_tr_meta_venta_tipo_ic_cat_tr_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_ic_cat_tr_meta_venta_tipo_ic_cat_tr_vendedor` FOREIGN KEY (`id_vendedor`) REFERENCES `ic_cat_tr_vendedor` (`id_vendedor`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_ic_cat_tr_meta_venta_tipo_st_adm_tr_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_empresa` (`id_empresa`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;
