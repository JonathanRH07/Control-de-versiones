CREATE TABLE `ic_cat_tr_meta_venta` (
  `id_meta_venta` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) NOT NULL,
  `clave` varchar(15) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `id_tipo_meta` int(11) NOT NULL,
  `total` decimal(15,2) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_meta_venta`),
  KEY `fk_ic_cat_tr_meta_venta_st_adm_tr_grupo_empresa_idx` (`id_grupo_empresa`) USING BTREE,
  KEY `fk_ic_cat_tr_meta_venta_ic_cat_tc_tipo_meta_idx` (`id_tipo_meta`) USING BTREE,
  CONSTRAINT `fk_ic_cat_tr_meta_venta_ic_cat_tc_tipo_meta` FOREIGN KEY (`id_tipo_meta`) REFERENCES `ic_cat_tc_tipo_meta` (`id_tipo_meta`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_ic_cat_tr_meta_venta_st_adm_tr_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=latin1;
