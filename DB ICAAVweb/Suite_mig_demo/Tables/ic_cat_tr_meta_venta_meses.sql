CREATE TABLE `ic_cat_tr_meta_venta_meses` (
  `id_meta_venta_meses` int(11) NOT NULL AUTO_INCREMENT,
  `id_meta_venta_tipo` int(11) NOT NULL,
  `anio` int(11) NOT NULL,
  `mes` int(11) NOT NULL,
  `meta` decimal(15,2) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_meta_venta_meses`),
  KEY `fk_ic_cat_tr_meta_venta_meses_ic_cat_tr_meta_venta_tipo_idx` (`id_meta_venta_tipo`) USING BTREE,
  CONSTRAINT `fk_ic_cat_tr_meta_venta_meses_ic_cat_tr_meta_venta_tipo` FOREIGN KEY (`id_meta_venta_tipo`) REFERENCES `ic_cat_tr_meta_venta_tipo` (`id_meta_venta_tipo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=latin1;
