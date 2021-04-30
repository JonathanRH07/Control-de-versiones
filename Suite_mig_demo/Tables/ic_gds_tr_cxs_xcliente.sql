CREATE TABLE `ic_gds_tr_cxs_xcliente` (
  `id_cxs_xcliente` int(11) NOT NULL AUTO_INCREMENT,
  `id_gds_cxs` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `importe` decimal(16,2) DEFAULT NULL,
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_cxs_xcliente`),
  KEY `fk_cxs_xcli_cliente_idx` (`id_cliente`),
  KEY `fk_cxs_xcli_csx_idx` (`id_gds_cxs`),
  KEY `fk_cxs_xclo_usuario_idx` (`id_usuario`),
  CONSTRAINT `fk_cxs_xcli_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxs_xcli_csx` FOREIGN KEY (`id_gds_cxs`) REFERENCES `ic_gds_tr_cxs` (`id_gds_cxs`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cxs_xclo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
