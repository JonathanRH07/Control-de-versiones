CREATE TABLE `ic_fac_tr_addenda` (
  `id_addenda` int(11) NOT NULL AUTO_INCREMENT,
  `id_addenda_default` int(11) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `addenda` text,
  `estatus` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_addenda`),
  KEY `fk_addenda_addenda_default_idx` (`id_addenda_default`) USING BTREE,
  KEY `fk_addenda_usuario_idx` (`id_usuario`) USING BTREE,
  KEY `fk_addenda_cliente_idx` (`id_cliente`) USING BTREE,
  CONSTRAINT `fk_addenda_addenda_default` FOREIGN KEY (`id_addenda_default`) REFERENCES `ic_glob_tr_addenda_default` (`id_addenda_default`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_addenda_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `ic_cat_tr_cliente` (`id_cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_addenda_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `suite_mig_conf`.`st_adm_tr_usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
