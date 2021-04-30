CREATE TABLE `ic_gds_tr_cxs` (
  `id_gds_cxs` int(11) NOT NULL AUTO_INCREMENT,
  `id_grupo_empresa` int(11) DEFAULT NULL,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_servicio` int(11) DEFAULT NULL,
  `id_serie` int(11) DEFAULT NULL,
  `id_forma_pago` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `referencia` varchar(10) DEFAULT NULL,
  `importe` decimal(16,2) DEFAULT NULL,
  `incluye_impuesto` char(1) DEFAULT 'N',
  `en_otra_serie` char(1) DEFAULT 'N',
  `imprime` char(1) DEFAULT 'N',
  `automatico` char(1) DEFAULT 'N',
  `forma_pago_gds` char(2) DEFAULT NULL,
  `alcance` enum('NACIONAL','INTERNACIONAL','TODOS') DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_gds_cxs`),
  KEY `fk_cxs_grupo_empresa_idx` (`id_grupo_empresa`),
  KEY `fk_cxc_proveedor_idx` (`id_proveedor`),
  KEY `fk_cxs_servicio_idx` (`id_servicio`),
  KEY `fk_cxs_serie_idx` (`id_serie`),
  KEY `fk_cxs_producto_idx` (`id_producto`),
  KEY `fk_cxs_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_cxs_grupo_empresa` FOREIGN KEY (`id_grupo_empresa`) REFERENCES `suite_mig_conf`.`st_adm_tr_grupo_empresa` (`id_grupo_empresa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxs_producto` FOREIGN KEY (`id_producto`) REFERENCES `ic_cat_tc_producto` (`id_producto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxs_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxs_serie` FOREIGN KEY (`id_serie`) REFERENCES `ic_cat_tr_serie` (`id_serie`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxs_servicio` FOREIGN KEY (`id_servicio`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxs_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8;