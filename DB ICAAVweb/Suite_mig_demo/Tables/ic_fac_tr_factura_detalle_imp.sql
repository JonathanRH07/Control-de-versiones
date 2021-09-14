CREATE TABLE `ic_fac_tr_factura_detalle_imp` (
  `id_factura_detalle_imp` int(11) NOT NULL AUTO_INCREMENT,
  `id_factura_detalle` int(11) DEFAULT NULL,
  `id_impuesto` int(11) DEFAULT NULL,
  `base_valor` varchar(10) DEFAULT NULL,
  `base_valor_cantidad` decimal(15,2) DEFAULT NULL,
  `valor_impuesto` varchar(10) DEFAULT NULL,
  `cantidad` decimal(15,2) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_factura_detalle_imp`),
  KEY `fk_fdetalle_imp_usuario_idx` (`id_usuario`),
  KEY `fk_detalle_imp_detalle_idx` (`id_factura_detalle`),
  KEY `fk_detalle_imp_impuesto_idx` (`id_impuesto`),
  CONSTRAINT `fk_detalle_imp_detalle` FOREIGN KEY (`id_factura_detalle`) REFERENCES `ic_fac_tr_factura_detalle` (`id_factura_detalle`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_imp_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11081 DEFAULT CHARSET=utf8;
