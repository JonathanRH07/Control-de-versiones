CREATE TABLE `ic_gds_tr_impuestos` (
  `id_gds_impuesto` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `intdom` enum('NACIONAL','INTERNACIONAL') DEFAULT NULL,
  `id_impuesto1` int(11) DEFAULT NULL,
  `id_impuesto2` int(11) DEFAULT NULL,
  `id_impuesto3` int(11) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_gds_impuesto`),
  KEY `fk_impuesto_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `fk_impuesto_producto_idx` (`id_producto`),
  KEY `fk_impuesto_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_impuesto_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_impuesto_producto` FOREIGN KEY (`id_producto`) REFERENCES `ic_cat_tc_producto` (`id_producto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_impuesto_usuario_gds` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;
