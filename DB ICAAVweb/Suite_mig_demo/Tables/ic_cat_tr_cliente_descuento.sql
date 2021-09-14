CREATE TABLE `ic_cat_tr_cliente_descuento` (
  `id_cliente_descuento` int(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_servicio` int(11) DEFAULT NULL,
  `descuento` decimal(16,2) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_cliente_descuento`),
  KEY `fk_cliente_desc_idx` (`id_cliente`),
  KEY `fk_cliente_descuento_usuario_idx` (`id_usuario`),
  KEY `fk_servicio_descuento_idx` (`id_servicio`),
  KEY `fk_prov_servicio_idx` (`id_proveedor`),
  CONSTRAINT `fk_cliente_desc` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cliente_descuento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_proveedor_descuento` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_servicio_descuento` FOREIGN KEY (`id_servicio`) REFERENCES `ic_cat_tc_servicio` (`id_servicio`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;
