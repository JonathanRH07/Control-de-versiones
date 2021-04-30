CREATE TABLE `ic_cat_tr_proveedor_aero` (
  `id_proveedor_aero` int(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` int(11) DEFAULT NULL,
  `id_pac` int(11) DEFAULT NULL,
  `codigo_bsp` char(10) DEFAULT NULL,
  `tipo_boleto` enum('NACIONAL','INTERNACIONAL','AMBOS') DEFAULT NULL,
  `bajo_costo` enum('SI','NO') DEFAULT NULL,
  `envia_factura` enum('SI','NO') DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_proveedor_aero`),
  KEY `idx_codigo_bsp` (`codigo_bsp`),
  KEY `fk_proveedor_aero_idx` (`id_proveedor`) USING BTREE,
  KEY `fk_proveedor_pac_idx` (`id_pac`) USING BTREE,
  KEY `fk_proveedor_aero_usuario_idx` (`id_usuario`) USING BTREE,
  CONSTRAINT `fk_proveedor_aero` FOREIGN KEY (`id_proveedor`) REFERENCES `ic_cat_tr_proveedor` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_proveedor_aero_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_proveedor_pac` FOREIGN KEY (`id_pac`) REFERENCES `ct_glob_tc_pac` (`id_pac`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8;
