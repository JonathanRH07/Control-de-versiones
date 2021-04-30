CREATE TABLE `ic_fac_tr_prove_cta_egreso` (
  `id_prove_cta_egreso` int(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_num_cta_conta` int(11) DEFAULT NULL,
  `id_num_cta_conta_costos` int(11) DEFAULT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `prorrateo` decimal(15,2) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_prove_cta_egreso`),
  KEY `fk_egreso_proveedor_idx` (`id_proveedor`),
  KEY `fk_cta_egreso_usuario_idx` (`id_usuario`),
  KEY `fk_cta_egreso_sucursal_idx` (`id_sucursal`),
  CONSTRAINT `fk_cta_egreso_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `ic_cat_tr_sucursal` (`id_sucursal`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cta_egreso_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_egreso_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=549 DEFAULT CHARSET=utf8;
